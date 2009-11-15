#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-window.h>

static gboolean delete_event( GtkWidget *widget, GdkEvent *event, gpointer data ) {
	_chisel_native_window_will_close_callback( widget );
}

native_handle _chisel_native_window_create( ) {
	GtkWidget *window;
	
	window = (GtkWidget *)gtk_window_new( GTK_WINDOW_TOPLEVEL );
	
	g_signal_connect( G_OBJECT(window), "delete_event", G_CALLBACK(delete_event), NULL );
	
	GtkWidget *container = gtk_vbox_new( FALSE, 0 );
	
	gtk_container_add( GTK_CONTAINER(window), container );
	
	GtkWidget *contentView = gtk_fixed_new( );
	gtk_container_add( GTK_CONTAINER(container), contentView );
	
	g_object_set_data( G_OBJECT(window), "chisel-window-container", container );
	g_object_set_data( G_OBJECT(window), "chisel-content-view", contentView );
	
	return (native_handle)window;
}

void _chisel_native_window_set_title( native_handle native, native_handle str ) {
	GtkWidget *window = (GtkWidget *)native;
	GString *string = (GString *)str;
	
	gtk_window_set_title( GTK_WINDOW(window), string->str );
}

void _chisel_native_window_set_content_size( native_handle native, Size size ) {
	GtkWidget *window = (GtkWidget *)native;
	
	gtk_window_resize( GTK_WINDOW(window), size.width, size.height ); // not quite!
}

void _chisel_native_window_set_visible( native_handle native, int visibility ) {
	GtkWidget *window = (GtkWidget *)native;
	
	if ( visibility ) {
		gtk_widget_show( window );
	} else {
		gtk_widget_hide( window );
	}
}

native_handle _chisel_native_window_get_content_view( native_handle native ) {
	GtkWidget *window = (GtkWidget *)native;
	
	GtkWidget *contentView = g_object_get_data( G_OBJECT(window), "chisel-content-view" );
	
	return contentView;
}

void _chisel_native_window_set_content_view( native_handle native, native_handle nview ) {
	GtkWidget *window = (GtkWidget *)native;

	GtkWidget *container = g_object_get_data( G_OBJECT(window), "chisel-window-container" );
	GtkWidget *contentView = GTK_WIDGET(nview);
	
	// FIXME: actually replace it in the packing in container
	
	g_object_set_data( G_OBJECT(window), "chisel-content-view", contentView );
}

void _chisel_native_window_close( native_handle native ) {
	GtkWidget *window = (GtkWidget *)native;
	
	gtk_widget_destroy( window );
}

void _chisel_native_window_set_menubar( native_handle nwindow, native_handle nmenubar ) {
	GtkWidget *window = (GtkWidget *)nwindow;
}

native_handle _chisel_native_window_get_menubar( native_handle nwindow ) {
	GtkWidget *window = (GtkWidget *)nwindow;
	
	return NULL;
}
