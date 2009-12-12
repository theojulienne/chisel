import os

env = Environment(
	ENV = os.environ,

	DFLAGS=['-version=Posix','-I/usr/include/d/','-g','-gc'],
#	CFLAGS=['-Ichisel/core/native/'],
	FRAMEWORKS=['Cocoa'],
#	LIBS=['gphobos', 'gtango'],
	LINKFLAGS=['-L.']
)

from os.path import exists
import sys

if env.Detect( ['dmd', 'gdmd', 'ldmd'] ) == 'ldmd':
	if exists('/usr/lib/d/'):
		env.Append( LINKFLAGS=['-L/usr/lib/d'] )
		env.Append( LIBS=['tango-ldc'] )
	else:
		env.Append( LINKFLAGS=['-L/usr/local/ldc/ldc/lib'] )
		env.Append( LIBS=['tango-user-ldc','tango-base-ldc'] )
else:
	if exists( '/usr/lib/libgtango.a' ):
		env.Append( LIBS=['gtango'] )
		env.Append( DFLAGS=['-version=Tango'] )
	elif exists( '/usr/lib/libgphobos.a' ):
		env.Append( LIBS=['gphobos'] )



platform_name = ''

if sys.platform == "darwin":
	env.Append( CFLAGS=['-m32'] )
	env.Append( LINKFLAGS=['-m32'] )
	platform_name = 'macosx'

if sys.platform.startswith( 'linux' ):
	platform_name = 'gtk'
	env.ParseConfig( 'pkg-config --cflags --libs gtk+-2.0 gtkgl-2.0' )

if sys.platform == 'win32':
	# chisel currently doesn't natively support windows, so use GTK
	platform_name = 'gtk'
	
	env.ParseConfig( 'pkg-config --cflags --libs gtk+-2.0' )
	env.Append( LIBS=['opengl32'] )
	env.Append( LIBS=['gphobos'] )
	
assert platform_name != ''

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
	sources += glob( 'chisel/%s/%s/*.c' % (package,platform_name) )
	sources += glob( 'chisel/%s/%s/*.m' % (package,platform_name) )
	
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
	
	if sys.platform == 'win32':
		lib = sub_env.StaticLibrary( target, sources )
	else:
		lib = sub_env.Library( target, sources )
	libs[package] = lib

for package in CHISEL_PACKAGES:
	for dep in CHISEL_DEPS[package]:
		Depends( libs[package], libs[dep] )

CHISEL_LIBS = libs.values( )

Export( 'env', 'CHISEL_LIBS' )

env.SConscript( 'examples/SConscript' )
