from classes import Class

import os
import os.path
import shutil

class Namespace(object):
	def __init__( self, name ):
		self._name = name
		self.namespaces = []
		self.classes = []
	
	def addNamespace( self, name ):
		ns = Namespace( name )
		
		self.namespaces.append( ns )
		
		return ns
	
	def addClass( self, name, *args, **kwargs ):
		cls = Class( name, *args, **kwargs )
		
		self.classes.append( cls )
		
		return cls
	
	def addPremadeClass( self, name, *args, **kwargs ):
		kwargs['premade'] = True
		
		cls = Class( name, *args, **kwargs )
		
		self.classes.append( cls )
		
		return cls
	
	def getPath( self ):
		try:
			parent_path = self._chisel_namespace.getPath( )
		except:
			parent_path = ''
		if parent_path != '':
			parent_path += '.'
		return parent_path + self.name
	
	@property
	def name( self ):
		return self._name.lower()
	
	def generateMakefile( self, path ):
		mf = open( path, 'wb' )
		
		mf.write( 'all: jni\n\n' )
		
		mf.write( 'jni: jniheaders\n' )
		
		
		classes = self.get_classes( )
		
		headerlist = [ 'jni/'+c.replace('.','_')+'.h' for c in classes ]
		classlist = [ ''+c.replace('.','/')+'.class' for c in classes ]
		javalist = [ ''+c.replace('.','/')+'.java' for c in classes ]
		
		mf.write( 'jniheaders: %s\n' % (' '.join(headerlist),))
		
		for i in range(len(classes)):
			cls = classes[i]
			hfile = headerlist[i]
			classfile = classlist[i]
			javafile = javalist[i]
			
			mf.write( '%s: %s\n' % (hfile, classfile) )
			mf.write( '\tjavah -d jni -jni %s\n' % (cls,) )
			mf.write( '\n' )
			mf.write( '%s: %s\n' % (classfile, javafile) )
			mf.write( '\tjavac %s\n' % (javafile,) )
			mf.write( '\n' )
			mf.write( '\n' )
		
		mf.close( )
	
	def get_classes( self, namespace_path=[] ):
		classes = []
		
		my_ns_path = namespace_path + [self.name]
		
		for cls in self.classes:
			classes.append( '.'.join( my_ns_path + [cls.name] ) )
		
		for ns in self.namespaces:
			classes += ns.get_classes( my_ns_path )
		
		return classes
	
	def generate( self, output_path, namespace_path=[] ):
		if len(namespace_path) == 0:
			self.generateMakefile( output_path + '/Makefile' )
		
		my_path = output_path + '/' + self.name
		if not os.path.exists(my_path):
			os.makedirs( my_path )
		
		my_ns_path = namespace_path + [self.name] 
		
		for namespace in self.namespaces:
			namespace._chisel_namespace = self
			namespace.generate( my_path, my_ns_path )
		
		for cls in self.classes:
			cls._chisel_namespace = self
			cls.generate( my_path, my_ns_path )