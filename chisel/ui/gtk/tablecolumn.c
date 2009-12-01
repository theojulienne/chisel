#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-string.h>
#include <chisel-native-tablecolumn.h>
#include <chisel-native-treeview.h>

static void get_cell_data( GtkTreeViewColumn *tree_column, GtkCellRenderer *cell, GtkTreeModel *tree_model, GtkTreeIter *iter, gpointer data ) {
	//printf( "get_cell_data( %p, %p, %p, %p, %p )\n", tree_column, cell, tree_model, iter, data );
	
	GtkWidget *treeview = g_object_get_data( G_OBJECT(tree_model), "chisel-treeview" );
	
	native_handle item = iter->user_data;
	
	native_handle value = _chisel_native_treeview_value_for_column_callback( treeview, (native_handle)item, (native_handle)tree_column );
	
	GString *string = (GString *)g_object_get_data( G_OBJECT(value), "gstring" );
	
	g_object_set( cell, "text", string->str, NULL );
}

native_handle _chisel_native_tablecolumn_create( ) {
	GtkTreeViewColumn *column = gtk_tree_view_column_new( );
	
	GtkCellRenderer *renderer = gtk_cell_renderer_text_new( );
	
	gtk_tree_view_column_pack_start( column, renderer, TRUE );
	gtk_tree_view_column_set_cell_data_func( column, renderer, get_cell_data, NULL, NULL );
	
	return (native_handle)column;
}

void _chisel_native_tablecolumn_set_title( native_handle ntablecolumn, native_handle ntitle ) {
	GtkTreeViewColumn *column = GTK_TREE_VIEW_COLUMN(ntablecolumn);
	GString *title = (GString *)g_object_get_data( G_OBJECT(ntitle), "gstring" );
	
	gtk_tree_view_column_set_title( column, title->str );
}

native_handle _chisel_native_tablecolumn_get_title( native_handle ntablecolumn ) {
	const gchar *title = gtk_tree_view_column_get_title( GTK_TREE_VIEW_COLUMN(ntablecolumn) );
	return _chisel_native_string_create_with_utf8_bytes( (char*)title, strlen(title) );
}

void _chisel_native_tablecolumn_set_identifier( native_handle ntablecolumn, native_handle identifier ) {
	g_object_set_data( G_OBJECT(ntablecolumn), "identifier", identifier );
}

native_handle _chisel_native_tablecolumn_get_identifier( native_handle ntablecolumn ) {
	return g_object_get_data( G_OBJECT(ntablecolumn), "identifier" );
}

