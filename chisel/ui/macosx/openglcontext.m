#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-openglcontext.h>

void _chisel_native_openglcontext_clear_current_context( ) {
	[NSOpenGLContext clearCurrentContext];
}

native_handle _chisel_native_openglcontext_get_current_context( ) {
	return (native_handle)[NSOpenGLContext currentContext];
}

void _chisel_native_openglcontext_update( native_handle handle ) {
	NSOpenGLContext *ctx = (NSOpenGLContext *)handle;
	
	[ctx update];
}

void _chisel_native_openglcontext_make_current_context( native_handle handle ) {
	NSOpenGLContext *ctx = (NSOpenGLContext *)handle;
	
	[ctx makeCurrentContext];
}
