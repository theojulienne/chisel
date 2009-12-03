#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-checkbox.h>

#include "compathacks.h"

void _chisel_gtk_checkbox_changed_event( GtkWidget *widget, GdkEvent *event, gpointer data ) {
    _chisel_native_checkbox_changed_callback( (native_handle)widget );
}

native_handle _chisel_native_checkbox_create( ) {
	GtkWidget *widget = gtk_check_button_new( );
	
	g_signal_connect( G_OBJECT(widget), "changed", G_CALLBACK(_chisel_gtk_checkbox_changed_event), NULL );
	
	return (native_handle)widget;
}

void _chisel_native_checkbox_set_enabled( native_handle native, int val ) {
	gtk_widget_set_sensitive( GTK_WIDGET(native), val );
	
	_chisel_force_gtk_refresh( );
}

int _chisel_native_checkbox_get_enabled( native_handle native ) {
	return gtk_widget_get_sensitive( GTK_WIDGET(native) );
}

void _chisel_native_checkbox_set_checked( native_handle native, int val ) {
	gtk_toggle_button_set_active( GTK_TOGGLE_BUTTON(native), val );
	
	_chisel_force_gtk_refresh( );
}

int _chisel_native_checkbox_get_checked( native_handle native ) {
	return gtk_toggle_button_get_active( GTK_TOGGLE_BUTTON(native) );
}

void _chisel_native_checkbox_set_text( native_handle native, native_handle s ) {
	GtkWidget *widget = GTK_WIDGET(native);
	GString *string = (GString *)g_object_get_data( G_OBJECT(s), "gstring" );
	
	gtk_button_set_label( GTK_BUTTON(widget), string->str );
	
	_chisel_force_gtk_refresh( );
}

CLFloat _chisel_native_checkbox_get_height( native_handle native ) {
	return 20.0;
}
