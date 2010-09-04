import os
import os.path

def getCName( orig ):
	name = ''
	
	for c in orig:
		if c.isupper():
			name += '_'
		name += c.lower( )
	
	return name

class SharedInstance(object):
	def __init__( self, name ):
		self.name = name
	
	def generateCS( self, data ):
		data.update( {'name': self.name} )
		return None
		return """
		private static %(class_name)s _%(name)s = null;

		public static %(class_name)s %(name)s( ) {
			if ( _%(name)s == null ) {
				_%(name)s = new %(class_name)s( );
			}

			return _%(name)s;
		}""" % data
		
	def generateHeader( self, data ):
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
		
	def generateCS( self, data ):
		data.update( {
			'name': self.name,
			'type': self.getType( ).getCSType( ),
			'c_name': '' + getCName( self.name ),
			'proxy_type': self.getType( ).getCSProxyType( ),
		} )
		
		converter = self.getType( ).getConverter( )
		data['set_value'] = converter.convertToNative( 'value' )
		data['get_value'] = converter.convertFromNative( '_native_get_%(name)s( nativeHandle )' % data )
		
		#print 'property', self.name, self._type
		return """
		[DllImport("chisel-%(lib)s-native", EntryPoint="%(chisel_prefix)s_set_%(c_name)s", CallingConvention=CallingConvention.Cdecl)]
		private static extern void _native_set_%(name)s( IntPtr native, %(proxy_type)s value );
		[DllImport("chisel-%(lib)s-native", EntryPoint="%(chisel_prefix)s_get_%(c_name)s", CallingConvention=CallingConvention.Cdecl)]
		private static extern %(proxy_type)s _native_get_%(name)s( IntPtr native );
		
		public %(type)s %(name)s {
			get { return %(get_value)s; }
			set { _native_set_%(name)s( nativeHandle, %(set_value)s ); }
		}
		""" % data
		
	def generateHeader( self, data ):
		data.update( {
			'c_type': self.getType( ).getCType( ),
			'c_name': getCName( self.name ),
		} )
		
		return [
			'void %(chisel_prefix)s_set_%(c_name)s( native_handle, %(c_type)s );' % data,
			'%(c_type)s %(chisel_prefix)s_get_%(c_name)s( native_handle );' % data
		]

class Function(object):
	def __init__( self, name, returns, takes ):
		self.name = name
		self.returns = returns
		self.takes = takes

	def generateCS( self, data ):
		args = []
		
		if self.takes is not None:
			for (jtype, name) in self.takes:
				if isinstance(jtype,Class):
					t = jtype.name
				else:
					t = jtype.getCSType( )
				args.append( t + ' ' + name )
		
		data.update( {
			'name': self.name,
			'return_type': 'void',
			'args': ', '.join( args ),
			'func_name': getCName( self.name ),
			'args_prefix_comma': ',',
			'maybe_return': 'return ',
		} )
		
		if self.returns is not None:
			data['return_type'] = self.returns( ).getCSType( )
		
		if len(args) == 0:
			data['args_prefix_comma'] = ''
		
		if data['return_type'] == 'void':
			data['maybe_return'] = ''
		
		return """
		[DllImport("chisel-%(lib)s-native", EntryPoint="%(chisel_prefix)s_%(func_name)s", CallingConvention=CallingConvention.Cdecl)]
		private static extern %(return_type)s _native_%(name)s( IntPtr native%(args_prefix_comma)s %(args)s );
		
		public %(return_type)s %(name)s( %(args)s ) {
			%(maybe_return)s_native_%(name)s( nativeHandle );
		}
		""" % data
	
	def generateHeader( self, data ):
		data.update( {
			'func_name': getCName( self.name ),
		} )
		
		return [
			'void %(chisel_prefix)s_%(func_name)s( native_handle );' % data
		]

class Constructor(object):
	def __init__( self, args ):
		self.args = args
		
	def generateCS( self, data ):
		args = []
		
		prop_sets = []
		
		for arg in self.args:
			if isinstance(arg, basestring):
				# direct link to property!
				prop = self._chisel_class.getProperty(arg)
				args.append( prop.getType( ).getCSType( ) + ' ' + arg )
				prop_sets.append( 'this.' + prop.name + ' = ' + arg + ';')
		
		data.update( {
			'args': ', '.join(args),
			'prop_sets': '\n\t\t\t'.join( prop_sets )
		} )
		
		return """
		public %(class_name)s( %(args)s ) {
			nativeHandle = initNative( );
			%(prop_sets)s
		}
		""" % data
		
	def generateHeader( self, data ):
		pass

from types import Converter, NativeType
class ClassConverter(Converter):
	pass

class Class(NativeType):
	def __init__( self, name, superclass=None, premade=False ):
		self._name = name
		self.superclass = superclass
		self.fields = []
		self.field_lookup = {}
		self.premade = premade
	
	def getCSType( self ):
		return self.name
	
	def getCType( self ):
		return 'native_handle'
	
	def getConverter( self ):
		return ClassConverter( )
	
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
			self.generateCS( output_path, namespace_path )

	def generatePremade( self, my_path, namespace_path ):
		file_base = os.path.dirname(__file__)
		premade_base = '/'.join( [file_base,'premade'] + namespace_path )
		
		my_j_path = my_path + '/' + self.name + '.cs'
		my_c_path = my_path + '/' + self.name + '.c'
		
		filename = self.name + '.cs'
		src_file = premade_base + '/' + filename
		f = open( my_j_path, 'wb' )
		f.write( open( src_file, 'rb' ).read() )
		f.close( )

	def generateCS( self, my_path, namespace_path ):
		f = open( my_path + '/' + self.name + '.cs', 'wb' )
		f.write( 'namespace %s {\n' % '.'.join(namespace_path) )
		f.write( '\n' )
		superdef = ''
		if self.superclass is not None:
			cls = self.superclass
			namespace = cls._chisel_namespace
			if namespace != self._chisel_namespace:
				f.write( 'using %s;\n\n' % namespace.getPath( ) )
			superdef = ' : ' + self.superclass.name
		f.write( 'using System;\n\n' )
		f.write( 'using System.Runtime.InteropServices;\n\n' )
		
		f.write( 'public class %s%s {\n' % (self.name, superdef) )
		#f.write( '\tstatic { System.loadLibrary( "%s" ); }\n' % '-'.join(namespace_path) )
		#f.write( '\tprivate native void initNative( );')
		func_prefix = '_native_chisel_'+self._chisel_namespace.name.lower()+'_'+self.name.lower()
		f.write( '\t[DllImport("chisel-%s-native", EntryPoint="%s_init", CallingConvention=CallingConvention.Cdecl)]\n' % (self._chisel_namespace.name.lower( ),func_prefix) )
		f.write( '\tprivate static extern IntPtr initNative( );\n' )
		f.write( '\n' )
		f.write( '\tpublic %s fromNative( IntPtr native ) { return (%s)CObject.fromNative( typeof(%s), native ); }\n' % (self.name, self.name,self.name) )
		f.write( '\n' )
		for field in self.fields:
			data = {
				'class_name': self.name,
				'chisel_prefix': func_prefix,
				
				'lib': self._chisel_namespace.name.lower( ),
			}
			field._chisel_class = self
			defn = field.generateCS( data )
			if defn is not None:
				for line in defn.split( '\n' ):
					f.write( line[1:] + '\n' ) # skip first tab, HAX
		f.write( '}\n' )
		f.write( '\n' )
		f.write( '} // namespace\n' )
		f.close( )
	
	def generateHeader( self, func_prefix, cls_path ):
		f = open( cls_path, 'wb' )
		f.write( 'native_handle %s_init( void );\n' % func_prefix )
		for field in self.fields:
			data = {
				'class_name': self.name,
				'chisel_prefix': func_prefix,
				
				'lib': self._chisel_namespace.name.lower( ),
			}
			defn = field.generateHeader( data )
			if defn is not None:
				f.write( '\n'.join( defn ) + '\n' )
		f.close( )