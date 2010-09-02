#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-menu.h>

native_handle _chisel_native_menu_create( ) {
    GtkWidget *menu = gtk_menu_new( );
    
	return menu;
}

void _chisel_native_menu_insert_item( native_handle nmenu, uint index, native_handle nitem ) {
    GtkMenuShell *shell = (GtkMenuShell *)nmenu;
    GtkMenuItem *item = (GtkMenuItem *)nitem;
    
	gtk_menu_shell_insert( shell, GTK_WIDGET(item), index );
}

uint _chisel_native_menu_item_count( native_handle nmenu ) {
    GList *children = gtk_container_get_children( GTK_CONTAINER(nmenu) );
    
    uint count = g_list_length( children );
    g_list_free( children );
    
	return count;
}

native_handle _chisel_native_menu_item_get( native_handle nmenu, uint index ) {
	GList *children = gtk_container_get_children( GTK_CONTAINER(nmenu) );
    
    gpointer data = g_list_nth_data( children, index );
    g_list_free( children );
    
	return (native_handle)data;
}
