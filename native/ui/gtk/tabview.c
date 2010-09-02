#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-tabview.h>

native_handle _chisel_native_tabview_create( ) {
	GtkWidget *notebook = gtk_notebook_new( );
	
	return (native_handle)notebook;
}

void _chisel_native_tabview_insert_item( native_handle tabview, uint index, native_handle item ) {
	GtkWidget *label = (GtkWidget *)g_object_get_data( G_OBJECT(item), "tabview-label" );
	GtkWidget *child = (GtkWidget *)g_object_get_data( G_OBJECT(item), "tabview-child" );
	
	gtk_notebook_insert_page( GTK_NOTEBOOK(tabview), child, label, index );
	gtk_widget_show( GTK_WIDGET(child) );
}

void _chisel_native_tabview_remove_item( native_handle tabview, native_handle item ) {
	GtkWidget *child = (GtkWidget *)g_object_get_data( G_OBJECT(item), "tabview-child" );
	
	uint index = gtk_notebook_page_num( GTK_NOTEBOOK(tabview), GTK_WIDGET(child) );
	gtk_notebook_remove_page( GTK_NOTEBOOK(tabview), index );
}

uint _chisel_native_tabview_item_count( native_handle tabview ) {
	return gtk_notebook_get_n_pages( GTK_NOTEBOOK(tabview) );
}

native_handle _chisel_native_tabview_item_get( native_handle tabview, uint index ) {
	GtkWidget *child = gtk_notebook_get_nth_page( GTK_NOTEBOOK(tabview), index );
	gpointer tabviewitem = g_object_get_data( G_OBJECT(child), "tabviewitem" );
	
	return tabviewitem;
}

void _chisel_native_tabview_select_item( native_handle tabview, native_handle item ) {
	GtkWidget *child = (GtkWidget *)g_object_get_data( G_OBJECT(item), "tabview-child" );
	
	uint index = gtk_notebook_page_num( GTK_NOTEBOOK(tabview), GTK_WIDGET(child) );
	gtk_notebook_set_current_page( GTK_NOTEBOOK(tabview), index );
}

native_handle _chisel_native_tabview_get_selected_item( native_handle tabview ) {
	uint index = gtk_notebook_get_current_page( GTK_NOTEBOOK(tabview) );
	
	return _chisel_native_tabview_item_get( tabview, index );
}
