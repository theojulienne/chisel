#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-window.h>

#include "widgets.h"

static gboolean _chisel_gtk_delete_event( GtkWidget *widget, GdkEvent *event, gpointer data ) {
	_chisel_native_window_will_close_callback( widget );
	
	return FALSE;
}

native_handle _chisel_native_window_create( ) {
	GtkWidget *window;
	
	window = (GtkWidget *)gtk_window_new( GTK_WINDOW_TOPLEVEL );
	
	//gtk_container_set_reallocate_redraws( GTK_CONTAINER(window), TRUE ); 
	
	g_signal_connect( G_OBJECT(window), "delete_event", G_CALLBACK(_chisel_gtk_delete_event), NULL );
	
	GtkWidget *container = gtk_vbox_new( FALSE, 0 );
	
	gtk_container_add( GTK_CONTAINER(window), container );
	gtk_widget_show( GTK_WIDGET(container) );
	
	// top button
	GtkWidget *w = gtk_button_new_with_label( "hi" );
	gtk_box_pack_start( GTK_BOX(container), w, FALSE, FALSE, 0 );
	//gtk_widget_show( w );
	
	// create a holder for the contentView that takes up all remaining space in the window (after menu/status)
	GtkWidget *contentViewHolder = gtk_vbox_new( TRUE, 0 );
	gtk_box_pack_end( GTK_BOX(container), contentViewHolder, TRUE, TRUE, 0 );
	gtk_widget_show( GTK_WIDGET(contentViewHolder) );
	
	// create a default contentView, and add it to the holder
	GtkWidget *contentView = gtk_layout_new( NULL, NULL );
	g_object_set_data( G_OBJECT(contentView), "chisel-content-view", contentView );
	_chisel_gtk_setup_events( contentView );
	gtk_box_pack_start( GTK_BOX(contentViewHolder), contentView, TRUE, TRUE, 0 );
	gtk_widget_show( GTK_WIDGET(contentView) );
	
	// bottom button
	w = gtk_button_new_with_label( "hi" );
	gtk_box_pack_end( GTK_BOX(container), w, FALSE, FALSE, 0 );
	//gtk_widget_show( w );
	
	g_object_set_data( G_OBJECT(window), "chisel-window-container", container );
	g_object_set_data( G_OBJECT(window), "chisel-content-view-holder", contentViewHolder );
	g_object_set_data( G_OBJECT(window), "chisel-content-view", contentView );
	
	gtk_quit_add_destroy(1, GTK_OBJECT(window));
	
	return (native_handle)window;
}

void _chisel_native_window_set_title( native_handle native, native_handle str ) {
	GtkWidget *window = (GtkWidget *)native;
	GString *string = (GString *)g_object_get_data( G_OBJECT(str), "gstring" );
	
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

	GtkWidget *contentViewHolder = g_object_get_data( G_OBJECT(window), "chisel-content-view-holder" );

	GtkWidget *contentView = g_object_get_data( G_OBJECT(window), "chisel-content-view" );
	gtk_container_remove( GTK_CONTAINER(contentViewHolder), contentView );
	
	contentView = GTK_WIDGET(nview);
	gtk_container_add( GTK_CONTAINER(contentViewHolder), contentView );
	
	g_object_set_data( G_OBJECT(window), "chisel-content-view", contentView );
	
	gtk_widget_show( GTK_WIDGET(contentView) );
}

void _chisel_native_window_close( native_handle native ) {
	GtkWidget *window = (GtkWidget *)native;
	
	gtk_widget_destroy( window );
}

void _chisel_native_window_set_menubar( native_handle nwindow, native_handle nmenubar ) {
	GtkWidget *window = (GtkWidget *)nwindow;
	GtkWidget *container = g_object_get_data( G_OBJECT(window), "chisel-window-container" );
	
	gtk_box_pack_start( GTK_BOX(container), GTK_WIDGET(nmenubar), FALSE, FALSE, 0 );
	gtk_widget_show( GTK_WIDGET(nmenubar) );
}

native_handle _chisel_native_window_get_menubar( native_handle nwindow ) {
	GtkWidget *window = (GtkWidget *)nwindow;
	
	return NULL;
}
