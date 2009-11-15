#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-checkbox.h>

native_handle _chisel_native_checkbox_create( ) {
	GtkWidget *widget = gtk_check_button_new( );
	
	return (native_handle)widget;
}

void _chisel_native_checkbox_set_enabled( native_handle native, int val ) {
	gtk_widget_set_sensitive( GTK_WIDGET(native), val );
}

int _chisel_native_checkbox_get_enabled( native_handle native ) {
	return gtk_widget_get_sensitive( GTK_WIDGET(native) );
}

void _chisel_native_checkbox_set_checked( native_handle native, int val ) {
	gtk_toggle_button_set_active( GTK_TOGGLE_BUTTON(native), val );
}

int _chisel_native_checkbox_get_checked( native_handle native ) {
	return gtk_toggle_button_get_active( GTK_TOGGLE_BUTTON(native) );
}

void _chisel_native_checkbox_set_text( native_handle native, native_handle s ) {
	GtkWidget *widget = GTK_WIDGET(native);
	GString *string = (GString *)s;
	
	gtk_button_set_label( GTK_BUTTON(widget), string->str );
}

CLFloat _chisel_native_checkbox_get_height( native_handle native ) {
	return 20.0;
}
