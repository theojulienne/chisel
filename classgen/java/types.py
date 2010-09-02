
class NativeType(object):
	def getJavaType( self ):
		assert False

class StringType(NativeType):
	def getJavaType( self ):
		return 'String'

class BooleanType(NativeType):
	def getJavaType( self ):
		return 'Boolean'
