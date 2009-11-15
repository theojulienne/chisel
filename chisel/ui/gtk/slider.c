#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-slider.h>

native_handle _chisel_native_slider_create( ) {
	GtkWidget *widget = gtk_hscale_new_with_range( 0, 1, 0.001 );
	
	return (native_handle)widget;
}

void _chisel_native_slider_set_minimum( native_handle native, CLFloat minValue ) {
	
}

void _chisel_native_slider_set_maximum( native_handle native, CLFloat maxValue ) {
	
}

void _chisel_native_slider_set_value( native_handle native, CLFloat value ) {
	
}

CLFloat _chisel_native_slider_get_value( native_handle native ) {
	return 0.0;
}

CLFloat _chisel_native_slider_get_thickness( native_handle native ) {
	return 0.0;
}
