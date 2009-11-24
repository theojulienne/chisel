#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>
#include <gtk/gtkgl.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-openglcontext.h>

void _chisel_native_openglcontext_clear_current_context( ) {
	
}

native_handle _chisel_native_openglcontext_get_current_context( ) {
	GdkGLContext *context = gdk_gl_context_get_current( );
	return (native_handle)context;
}

void _chisel_native_openglcontext_update( native_handle handle ) {
	
}

void _chisel_native_openglcontext_make_current_context( native_handle handle ) {
	GdkGLContext *context = (GdkGLContext *)handle;
	GdkGLDrawable *drawable = gdk_gl_context_get_gl_drawable( context );
	
	/*
	GdkGLContext *current = gdk_gl_context_get_current( );
	if ( current != NULL ) {
		GdkGLDrawable *cdraw = gdk_gl_context_get_gl_drawable( current );
		
		gdk_gl_drawable_gl_end( cdraw );
	}
	
	gdk_gl_drawable_gl_begin( drawable, context );
	*/
}

void _chisel_native_openglcontext_flush_buffer( native_handle handle ) {
	GdkGLContext *context = (GdkGLContext *)handle;
	GdkGLDrawable *drawable = gdk_gl_context_get_gl_drawable( context );
	
	if ( gdk_gl_drawable_is_double_buffered( drawable ) ) {
		gdk_gl_drawable_swap_buffers( drawable );
	} else {
		glFlush( );
	}
	//gdk_gl_drawable_swap_buffers( drawable );
}

