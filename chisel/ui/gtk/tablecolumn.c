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

native_handle _chisel_native_tablecolumn_create( ) {
	return (native_handle)gtk_tree_view_column_new( );
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

