#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-frame.h>

native_handle _chisel_native_frame_create( ) {
	GtkWidget *widget = gtk_frame_new( "" );
	
	
	
	return (native_handle)widget;
}

void _chisel_native_frame_set_title( native_handle native, native_handle str ) {
	GtkWidget *widget = GTK_WIDGET(native);
	GString *string = (GString *)str;
	
	gtk_frame_set_label( GTK_FRAME(widget), string->str );
}

native_handle _chisel_native_frame_get_content_view( native_handle native ) {
	return NULL;
}

void _chisel_native_frame_set_content_view( native_handle native, native_handle nview ) {
	
}
