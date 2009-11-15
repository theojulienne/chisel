#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-frame.h>

#include "widgets.h"

native_handle _chisel_native_frame_create( ) {
	GtkWidget *widget = gtk_frame_new( "" );
	
	GtkWidget *contentView = gtk_layout_new( NULL, NULL );
	
	_chisel_gtk_setup_events( contentView );
	
	gtk_container_add( GTK_CONTAINER(widget), contentView );
	gtk_widget_show( GTK_WIDGET(contentView) );
	
	g_object_set_data( G_OBJECT(widget), "chisel-content-view", contentView );
	
	return (native_handle)widget;
}

void _chisel_native_frame_set_title( native_handle native, native_handle str ) {
	GtkWidget *widget = GTK_WIDGET(native);
	GString *string = (GString *)str;
	
	gtk_frame_set_label( GTK_FRAME(widget), string->str );
}

native_handle _chisel_native_frame_get_content_view( native_handle native ) {
	GtkWidget *widget = (GtkWidget *)native;
	
	GtkWidget *contentView = g_object_get_data( G_OBJECT(widget), "chisel-content-view" );
	
	return contentView;
}

void _chisel_native_frame_set_content_view( native_handle native, native_handle nview ) {
	GtkWidget *frame = (GtkWidget *)native;

	GtkWidget *contentView = g_object_get_data( G_OBJECT(frame), "chisel-content-view" );
	gtk_container_remove( GTK_CONTAINER(frame), contentView );
	
	contentView = GTK_WIDGET(nview);
	gtk_container_add( GTK_CONTAINER(frame), contentView );
	
	g_object_set_data( G_OBJECT(frame), "chisel-content-view", contentView );
	
	gtk_widget_show( GTK_WIDGET(contentView) );
}
