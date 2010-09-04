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
		return self._name
	
	def generateMakefile( self, path ):
		mf = open( path, 'wb' )
		
		mf.write( 'all:\n' )
		for namespace in self.namespaces:
			extra = ''
			
			if namespace.name != 'Core':
				extra += ' -reference:Chisel.Core.dll'
			
			mf.write( '\tgmcs chisel/%s/*.cs -target:library -out:Chisel.%s.dll%s\n' % (namespace.name.lower(), namespace.name, extra) )
		
		mf.write( '\tcp ../../native/core/macosx/libchisel-core-native.dylib .\n' )
		mf.write( '\tcp ../../native/ui/macosx/libchisel-ui-native.dylib .\n' )
		
		mf.write( 'test:\n\tgmcs Test.cs -reference:Chisel.Core.dll -reference:Chisel.UI.dll\n')
		
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
	
	def generateHeader( self, output_path, namespace_path=[] ):
		for ns in self.namespaces:
			path = output_path + '/' + ns.name + '/include'
			
			for cls in ns.classes:
				cls_path = path + '/chisel-'+ns.name+'-native-'+cls.name.lower()+'.h'
				func_prefix = '_native_chisel_'+ns.name.lower()+'_'+cls.name.lower()
				
				cls.generateHeader( func_prefix, cls_path )