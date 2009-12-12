#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-tabview.h>

#include <chisel-native-string.h>

native_handle _chisel_native_tabviewitem_create( ) {
	gpointer obj = g_object_new( G_TYPE_OBJECT, NULL );
	
	GtkWidget *label = gtk_label_new( "" );
	GtkWidget *child = gtk_vbox_new( TRUE, 0 );
	GtkWidget *contentView = _chisel_native_view_create( );
	
	gtk_container_add( GTK_CONTAINER(child), GTK_WIDGET(contentView) );
	gtk_widget_show( GTK_WIDGET(child) );
	gtk_widget_show( GTK_WIDGET(contentView) );
	
	g_object_set_data( G_OBJECT(obj), "tabview-label", (gpointer)label );
	g_object_set_data( G_OBJECT(obj), "tabview-child", (gpointer)child );
	g_object_set_data( G_OBJECT(obj), "tabview-content", (gpointer)contentView );
	
	g_object_set_data( G_OBJECT(obj), "tabviewitem", (gpointer)obj );
	
	return obj;
}

void _chisel_native_tabviewitem_set_title( native_handle tabviewitem, native_handle title ) {
	GtkWidget *label = (GtkWidget *)g_object_get_data( G_OBJECT(tabviewitem), "tabview-label" );
	GString *str = (GString *)g_object_get_data( G_OBJECT(title), "gstring" );
	
	gtk_label_set_text( GTK_LABEL(label), str->str );
	
	_chisel_force_gtk_refresh( );
}

native_handle _chisel_native_tabviewitem_get_title( native_handle tabviewitem ) {
	GtkWidget *label = (GtkWidget *)g_object_get_data( G_OBJECT(tabviewitem), "tabview-label" );
	const gchar *ret = gtk_label_get_text( GTK_LABEL(label) );
	
	return _chisel_native_string_create_with_utf8_bytes( (char*)ret, strlen(ret) );
}

native_handle _chisel_native_tabviewitem_get_content_view( native_handle tabviewitem ) {
	GtkWidget *content = (GtkWidget *)g_object_get_data( G_OBJECT(tabviewitem), "tabview-content" );
	
	return (native_handle)content;
}

void _chisel_native_tabviewitem_set_content_view( native_handle tabviewitem, native_handle newcontent ) {
	GtkWidget *child = (GtkWidget *)g_object_get_data( G_OBJECT(tabviewitem), "tabview-child" );
	GtkWidget *content = (GtkWidget *)g_object_get_data( G_OBJECT(tabviewitem), "tabview-content" );
	
	gtk_container_remove( GTK_CONTAINER(child), GTK_WIDGET(content) );
	gtk_container_add( GTK_CONTAINER(child), GTK_WIDGET(newcontent) );
	gtk_widget_show( GTK_WIDGET(newcontent) );
	
	g_object_set_data( G_OBJECT(tabviewitem), "tabview-content", (gpointer)newcontent );
}

