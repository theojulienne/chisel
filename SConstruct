env = Environment(
	DFLAGS=['-version=Tango','-version=Posix','-I/usr/include/d/'],
#	CFLAGS=['-Ichisel/core/native/'],
	FRAMEWORKS=['Cocoa'],
	LIBS=['gphobos', 'gtango'],
	LINKFLAGS=['-L.']
)

from glob import glob

CHISEL_PACKAGES = [ 'core', 'graphics', 'text', 'ui' ]

CHISEL_DEPS = {
	'core': [],
	'graphics': [ 'core' ],
	'text': [ 'core', 'graphics' ],
	'ui': [ 'core', 'graphics', 'text' ],
}

libs = {}

for package in CHISEL_PACKAGES:
	deps = CHISEL_DEPS[package]
	
	sources = []
	
	sources += glob( 'chisel/%s/*.d' % (package,) )
	sources += glob( 'chisel/%s/macosx/*.m' % (package,) )
	
	target = 'chisel-%s' % (package,)
	
	include_dirs = []
	
	link_libs = []
	
	for dep in deps + [package]:
		include_dirs.append( 'chisel/%s/native/' % (dep,) )
		
		if dep != package:
			link_libs.append( 'chisel-' + dep )
	
	cflags = []
	
	cflags += ('-I'+d for d in include_dirs)
	
	cflags_str = ' '.join( cflags )
	
	sub_env = env.Clone( )
	sub_env.Append( LIBS=link_libs )
	sub_env.Append( CFLAGS=cflags_str )
	
	lib = sub_env.SharedLibrary( target, sources )
	libs[package] = lib

for package in CHISEL_PACKAGES:
	for dep in CHISEL_DEPS[package]:
		Depends( libs[package], libs[dep] )

Export( 'env' )

env.SConscript( 'examples/SConscript' )