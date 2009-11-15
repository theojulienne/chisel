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

native_handle _chisel_native_openglview_create( ) {
	static int glsetup = 0;
	
	if ( !glsetup ) {
		gtk_gl_init_check( NULL, NULL );
		glsetup = 1;
	}
	
	GtkWidget *widget = gtk_layout_new( NULL, NULL );
	
	_chisel_gtk_setup_events( widget );
	
	GdkGLConfigMode glcmode = (GdkGLConfigMode)(GDK_GL_MODE_RGB
	                                | GDK_GL_MODE_DEPTH
	                                | GDK_GL_MODE_DOUBLE);
	
	GdkGLConfig *glconfig = gdk_gl_config_new_by_mode( glcmode );
	gtk_widget_set_gl_capability( widget, glconfig, NULL, TRUE, GDK_GL_RGBA_TYPE );
	
	return widget;
}

native_handle _chisel_native_openglview_opengl_context( native_handle handle ) {
	return NULL;
}
