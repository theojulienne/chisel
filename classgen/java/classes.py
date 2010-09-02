import os
import os.path

class SharedInstance(object):
	def __init__( self, name ):
		self.name = name
	
	def generateJava( self, data ):
		data.update( {'name': self.name} )
		return """
		private static %(class_name)s _%(name)s = null;

		public static %(class_name)s %(name)s( ) {
			if ( _%(name)s == null ) {
				_%(name)s = new %(class_name)s( );
			}

			return _%(name)s;
		}""" % data
	
	def generateJNI( self, data ):
		pass

class Property(object):
	def __init__( self, name, _type ):
		self.name = name
		self._type = _type
	
	def getType( self ):
		if isinstance(self._type,type):
			return self._type( )
		else:
			return self._type
	
	def getSetter( self ):
		return 'set' + self.name[0].upper() + self.name[1:]
	
	def getGetter( self ):
		return 'get' + self.name[0].upper() + self.name[1:]
	
	def generateJava( self, data ):
		data.update( {
			'getter': self.getGetter( ),
			'setter': self.getSetter( ),
			'type': self.getType( ).getJavaType( ),
		} )
		
		#print 'property', self.name, self._type
		return """
		public native %(type)s %(getter)s( );
		public native void %(setter)s( %(type)s value );
		""" % data
		
	def generateJNI( self, data ):
		pass

class Function(object):
	def __init__( self, name, returns, takes ):
		self.name = name
		self.returns = returns
		self.takes = takes

	def generateJava( self, data ):
		args = []
		
		if self.takes is not None:
			for (jtype, name) in self.takes:
				if isinstance(jtype,Class):
					t = jtype.name
				else:
					t = jtype.getJavaType( )
				args.append( t + ' ' + name )
		
		data.update( {
			'name': self.name,
			'return_type': 'void',
			'args': ', '.join( args ),
		} )
		
		if self.returns is not None:
			data['return_type'] = self.returns( ).getJavaType( )
		
		return """
		public native %(return_type)s %(name)s( %(args)s );
		""" % data
		
	def generateJNI( self, data ):
		pass

class Constructor(object):
	def __init__( self, args ):
		self.args = args
		
	def generateJava( self, data ):
		args = []
		
		prop_sets = []
		
		for arg in self.args:
			if isinstance(arg, basestring):
				# direct link to property!
				prop = self._chisel_class.getProperty(arg)
				args.append( prop.getType( ).getJavaType( ) + ' ' + arg )
				prop_sets.append( 'this.' + prop.getSetter( ) + '( ' + arg + ' );')
		
		data.update( {
			'args': ', '.join(args),
			'prop_sets': '\n\t\t\t'.join( prop_sets )
		} )
		
		return """
		public %(class_name)s( %(args)s ) {
			initNative( );
			%(prop_sets)s
		}
		""" % data
		
	def generateJNI( self, data ):
		pass

class Class(object):
	def __init__( self, name, superclass=None, premade=False ):
		self._name = name
		self.superclass = superclass
		self.fields = []
		self.field_lookup = {}
		self.premade = premade
	
	def getJavaType( self ):
		return self.name
	
	def addField( self, cls, name, *args, **kwargs ):
		field = cls( name, *args, **kwargs )
		self.fields.append( field )
		self.field_lookup[name] = field
	
	def addSharedInstance( self, name ):
		return self.addField( SharedInstance, name )
	
	def addProperty( self, name, type ):
		return self.addField( Property, name, type )
	
	def addFunction( self, name, returns=None, takes=None ):
		return self.addField( Function, name, returns, takes )
	
	def addConstructor( self, *args ):
		return self.addField( Constructor, args )
	
	def getProperty( self, name ):
		return self.field_lookup[name]
	
	@property
	def name( self ):
		return self._name

	def generate( self, output_path, namespace_path ):
		if self.premade:
			self.generatePremade( output_path, namespace_path )
		else:
			self.generateJava( output_path, namespace_path )

	def generatePremade( self, my_path, namespace_path ):
		file_base = os.path.dirname(__file__)
		premade_base = '/'.join( [file_base,'premade'] + namespace_path )
		
		my_j_path = my_path + '/' + self.name + '.java'
		my_c_path = my_path + '/' + self.name + '.c'
		
		filename = self.name + '.java'
		src_file = premade_base + '/' + filename
		f = open( my_j_path, 'wb' )
		f.write( open( src_file, 'rb' ).read() )
		f.close( )
		
		filename = self.name + '.c'
		src_file = premade_base + '/' + filename
		f = open( my_c_path, 'wb' )
		f.write( open( src_file, 'rb' ).read() )
		f.close( )

	def generateJava( self, my_path, namespace_path ):
		f = open( my_path + '/' + self.name + '.java', 'wb' )
		f.write( 'package %s;\n' % '.'.join(namespace_path) )
		f.write( '\n' )
		superdef = ''
		if self.superclass is not None:
			cls = self.superclass
			namespace = cls._chisel_namespace
			if namespace != self._chisel_namespace:
				f.write( 'import %s.*;\n\n' % namespace.getPath( ) )
			superdef = ' extends ' + self.superclass.name
		f.write( 'public class %s%s {\n' % (self.name, superdef) )
		f.write( '\tstatic { System.loadLibrary( "%s" ); }\n' % '-'.join(namespace_path) )
		f.write( '\tprivate native void initNative( );')
		for field in self.fields:
			data = {
				'class_name': self.name,
			}
			field._chisel_class = self
			defn = field.generateJava( data )
			if defn is not None:
				for line in defn.split( '\n' ):
					f.write( line[1:] + '\n' ) # skip first tab, HAX
		f.write( '}\n' )
		f.write( '\n' )
		f.close( )
		
		self.generateJNI( my_path, namespace_path )
	
	def generateJNI( self, my_path, ns_path ):
		jni_prefix = 'Java_' + '_'.join( ns_path ) + '_' + self.name
		
		# JNI c file
		f = open( my_path + '/' + self.name + '.c', 'wb' )
		f.write( '#include <assert.h>\n' )
		f.write( '\n' )
		f.write( '#include "%s.h"\n' % (self.name,) )
		f.write( '\n' )
		f.write( 'JNIEXPORT void JNICALL %s_initNative(JNIEnv *env, jobject obj) {\n' % (jni_prefix,))
		f.write( '\tjclass cls = (*env)->GetObjectClass(env, obj);\n' )
		f.write( '\tjfieldID fid = (*env)->GetFieldID(env, cls, "native_handle", "I");\n' )
		f.write( '\tassert( fid != NULL );\n' )
		f.write( '\tjint handle = (*env)->GetIntField(env, cls, fid);\n' )
		f.write( '\tprintf( "native: %p\\n", handle );\n' )
		f.write( '}\n')
		for field in self.fields:
			data = {
				'class_name': self.name,
				'jni_prefix': jni_prefix,
			}
			field._chisel_class = self
			defn = field.generateJNI( data )
			if defn is not None:
				for line in defn.split( '\n' ):
					f.write( line[1:] + '\n' ) # skip first tab, HAX
		f.write( '\n' )
		f.close( )