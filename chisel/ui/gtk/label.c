#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-label.h>

native_handle _chisel_native_label_create( ) {
	GtkWidget *widget = gtk_label_new( "" );
	
	gtk_misc_set_alignment( GTK_MISC(widget), 0, 0 );
	
	return (native_handle)widget;
}

void _chisel_native_label_set_selectable( native_handle native, int val ) {
	gtk_label_set_selectable( GTK_LABEL(native), val );
}

int _chisel_native_label_get_selectable( native_handle native ) {
	return gtk_label_get_selectable( GTK_LABEL(native) );
}

void _chisel_native_label_set_text( native_handle native, native_handle s ) {
	GString *str = (GString *)s;
	
	gtk_label_set_text( GTK_LABEL(native), str->str );
}

CLFloat _chisel_native_label_get_height( native_handle native ) {
	return 16.0; // FIXME: hax
}