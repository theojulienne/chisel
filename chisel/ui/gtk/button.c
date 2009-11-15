#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-button.h>

native_handle _chisel_native_button_create( ) {
	GtkWidget *widget = gtk_button_new( );
	
	return (native_handle)widget;
}

void _chisel_native_button_set_enabled( native_handle native, int val ) {
	
}

int _chisel_native_button_get_enabled( native_handle native ) {
	
}

void _chisel_native_button_set_text( native_handle native, native_handle s ) {
	
}

CLFloat _chisel_native_button_get_height( native_handle native ) {
	return 0.0;
}