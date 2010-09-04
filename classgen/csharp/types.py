
class Converter(object):
	def convertToNative( self, arg ):
		return arg
	
	def convertFromNative( self, arg ):
		return arg

class NativeType(object):
	def getCSType( self ):
		assert False
	def getCType( self ):
		assert False
	def getConverter( self ):
		return Converter( )
	def getCSProxyType( self ):
		return self.getCSType( )

## strings

class StringConverter(object):
	def convertToNative( self, arg ):
		return 'new CString( ' + arg + ' ).nativeHandle'

	def convertFromNative( self, arg ):
		return '((CString)CObject.fromNative(typeof(String), '+arg+')).cliString'

class StringType(NativeType):
	def getCSType( self ):
		return 'String'
	def getCSProxyType( self ):
		return 'IntPtr'
	def getCType( self ):
		return 'native_handle'
	def getConverter( self ):
		return StringConverter()

## booleans

class BooleanType(NativeType):
	def getCSType( self ):
		return 'Boolean'
	def getCType( self ):
		return 'int'
