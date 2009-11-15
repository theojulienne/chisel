#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-openglview.h>

native_handle _chisel_native_openglview_create( ) {
	return gtk_fixed_new( );
}

native_handle _chisel_native_openglview_opengl_context( native_handle handle ) {
	return NULL;
}
