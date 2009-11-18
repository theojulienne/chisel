#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-button.h>

#include "compathacks.h"

void _chisel_gtk_button_pushed_event( GtkWidget *widget, GdkEvent *event, gpointer data ) {
    _chisel_native_button_pressed_callback( (native_handle)widget );
}

native_handle _chisel_native_button_create( ) {
	GtkWidget *widget = gtk_button_new( );
	
	g_signal_connect( G_OBJECT(widget), "pressed", G_CALLBACK(_chisel_gtk_button_pushed_event), NULL );
	
	return (native_handle)widget;
}

void _chisel_native_button_set_enabled( native_handle native, int val ) {
	gtk_widget_set_sensitive( GTK_WIDGET(native), val );
}

int _chisel_native_button_get_enabled( native_handle native ) {
	return gtk_widget_get_sensitive( GTK_WIDGET(native) );
}

void _chisel_native_button_set_text( native_handle native, native_handle s ) {
	GtkWidget *widget = GTK_WIDGET(native);
	GString *string = (GString *)s;
	
	gtk_button_set_label( GTK_BUTTON(widget), string->str );
}

CLFloat _chisel_native_button_get_height( native_handle native ) {
	return 30.0;
}
