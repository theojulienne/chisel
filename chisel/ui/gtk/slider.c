#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-slider.h>

#include <chisel-native-enums.h>

native_handle _chisel_native_slider_create( int type ) {
	GtkWidget *widget;
	
	if ( type == SliderTypeHorizontal ) {
		widget = gtk_hscale_new_with_range( 0, 1, 0.001 );
	} else {
		widget = gtk_vscale_new_with_range( 0, 1, 0.001 );
	}
	
	gtk_scale_set_draw_value( GTK_SCALE(widget), FALSE );
	
	return (native_handle)widget;
}

void _chisel_native_slider_set_minimum( native_handle native, CLFloat minValue ) {
	GtkAdjustment *adj = gtk_range_get_adjustment( GTK_RANGE(native) );
	
	gtk_range_set_range( GTK_RANGE(native), minValue, gtk_adjustment_get_upper( adj ) );
}

void _chisel_native_slider_set_maximum( native_handle native, CLFloat maxValue ) {
	GtkAdjustment *adj = gtk_range_get_adjustment( GTK_RANGE(native) );
	
	gtk_range_set_range( GTK_RANGE(native), gtk_adjustment_get_lower( adj ), maxValue );
}

void _chisel_native_slider_set_value( native_handle native, CLFloat value ) {
	gtk_range_set_value( GTK_RANGE(native), value );
}

CLFloat _chisel_native_slider_get_value( native_handle native ) {
	return gtk_range_get_value( GTK_RANGE(native) );
}

CLFloat _chisel_native_slider_get_thickness( native_handle native ) {
	return 25.0;
}
