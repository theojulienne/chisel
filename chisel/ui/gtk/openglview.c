#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>
#include <gtk/gtkgl.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-openglview.h>

static gboolean _chisel_native_openglview_resize_event( GtkWidget *widget, GdkEvent *event, gpointer native_data ) {
	if ( GTK_WIDGET_REALIZED(widget) ) {
		assert( gtk_widget_is_gl_capable( widget ) );
		
		GdkGLDrawable *gldrawable = (GdkGLDrawable *)gtk_widget_get_gl_window( widget );
		GdkGLContext *glcontext = gtk_widget_get_gl_context( widget );
		
		gdk_gl_drawable_gl_begin( gldrawable, glcontext );

		_chisel_native_openglview_reshape_callback( (native_handle)widget );
		
		GtkAllocation allocation;
		gtk_widget_get_allocation( GTK_WIDGET(widget), &allocation );
		
		Rect rect;
		rect.origin.x = 0;//allocation.x;
		rect.origin.y = 0;//allocation.y;
		rect.size.width = allocation.width;
		rect.size.height = allocation.height;
		_chisel_native_view_invalidate_rect( (native_handle)widget, rect );
	
		gdk_gl_drawable_gl_end( gldrawable );
	}
	
	return TRUE;
}

static gboolean _chisel_native_openglview_expose_event( GtkWidget *widget, GdkEventExpose *event, gpointer native_data ) {
	if ( GTK_WIDGET_REALIZED(widget) ) {
		assert( gtk_widget_is_gl_capable( widget ) );
		
		GdkGLDrawable *gldrawable = (GdkGLDrawable *)gtk_widget_get_gl_window( widget );
		GdkGLContext *glcontext = gtk_widget_get_gl_context( widget );
		
		gdk_gl_drawable_gl_begin( gldrawable, glcontext );
		
		Rect rect;
		rect.origin.x = event->area.x;
		rect.origin.y = event->area.y;
		rect.size.width = event->area.width;
		rect.size.height = event->area.height;
		printf( "expose!\n" );
		_chisel_native_view_draw_rect_callback( (native_handle)widget, rect );
	
		gdk_gl_drawable_gl_end( gldrawable );
	}
	
	return TRUE;
}

native_handle _chisel_native_openglview_create( ) {
	static int glsetup = 0;
	
	if ( !glsetup ) {
		gtk_gl_init_check( NULL, NULL );
		glsetup = 1;
	}
	
	GtkWidget *widget = gtk_drawing_area_new( );
	
	_chisel_gtk_setup_events( widget );
	g_signal_connect( G_OBJECT(widget), "size_allocate", G_CALLBACK(_chisel_native_openglview_resize_event), NULL );
	g_signal_connect_after( G_OBJECT(widget), "realize", G_CALLBACK(_chisel_native_openglview_resize_event), NULL );
	g_signal_connect( G_OBJECT(widget), "expose_event", G_CALLBACK(_chisel_native_openglview_expose_event), NULL );
	
	gtk_widget_set_events( widget, GDK_EXPOSURE_MASK );

	
	GdkGLConfigMode glcmode = (GdkGLConfigMode)(GDK_GL_MODE_RGB
	                                | GDK_GL_MODE_DEPTH
	                                | GDK_GL_MODE_DOUBLE);

	GdkGLConfig *glconfig = gdk_gl_config_new_by_mode( glcmode );
	assert( glconfig != NULL );
	assert( gtk_widget_set_gl_capability( widget, glconfig, NULL, TRUE, GDK_GL_RGBA_TYPE ) );
	
	return widget;
}

native_handle _chisel_native_openglview_opengl_context( native_handle handle ) {
	return (native_handle)gtk_widget_get_gl_context( GTK_WIDGET(handle) );
}

