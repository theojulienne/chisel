#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-menuitem.h>

#include "compathacks.h"

void _chisel_gtk_menuitem_pushed_event( GtkWidget *widget, GdkEvent *event, gpointer data ) {
    _chisel_native_menuitem_pressed_callback( (native_handle)widget );
}

enum {
	ModifierKeyShift=0x01,
	ModifierKeyAlternate=0x02,
	ModifierKeyCommand=0x04,
	ModifierKeyControl=0x08,
	
	ModifierKeyNativeDefault=0x10,
};

native_handle _chisel_native_menuitem_create( ) {
    GtkWidget *menuitem = gtk_image_menu_item_new_with_label( "test" );
    
    gtk_widget_show( GTK_WIDGET(menuitem) );
    
    g_signal_connect( G_OBJECT(menuitem), "activate", G_CALLBACK(_chisel_gtk_menuitem_pushed_event), NULL );
    
	return (native_handle)menuitem;
}

native_handle _chisel_native_menuitem_create_separator( ) {
    GtkWidget *menuitem = gtk_separator_menu_item_new( );
    
    gtk_widget_show( GTK_WIDGET(menuitem) );
    
	return (native_handle)menuitem;
}

void _chisel_native_menuitem_set_submenu( native_handle nmenuItem, native_handle nsubmenu ) {
	gtk_menu_item_set_submenu( GTK_MENU_ITEM(nmenuItem), GTK_WIDGET(nsubmenu) );
}

native_handle _chisel_native_menuitem_get_submenu( native_handle nmenuItem ) {
	return (native_handle)gtk_menu_item_get_submenu( GTK_MENU_ITEM(nmenuItem) );
}

void _chisel_native_menuitem_set_enabled( native_handle nmenuItem, int flag ) {
	gtk_widget_set_sensitive( GTK_WIDGET(nmenuItem), flag );
}

int _chisel_native_menuitem_get_enabled( native_handle nmenuItem ) {
	return gtk_widget_get_sensitive( GTK_WIDGET(nmenuItem) );
}

void _chisel_native_menuitem_set_visible( native_handle nmenuItem, int flag ) {
    if ( flag ) {
    	gtk_widget_show( GTK_WIDGET(nmenuItem) );
    } else {
        gtk_widget_hide( GTK_WIDGET(nmenuItem) );
    }
}

int _chisel_native_menuitem_get_visible( native_handle nmenuItem ) {
	return 0;
}

void _chisel_native_menuitem_set_title( native_handle nmenuItem, native_handle ntitle ) {
	GtkWidget *menu_label = gtk_bin_get_child( GTK_BIN(nmenuItem) );
	GString *string = (GString *)g_object_get_data( G_OBJECT(ntitle), "gstring" );
	
	//printf( "TYPE: %s\n", g_type_name(G_TYPE_FROM_INSTANCE(menu_label)) );
	
	assert( GTK_IS_LABEL(menu_label) );
	printf( "%s\n", string->str );
    gtk_label_set_text( GTK_LABEL(menu_label), string->str ); 
}

native_handle _chisel_native_menuitem_get_title( native_handle nmenuItem ) {
	return NULL;
}

void _chisel_native_menuitem_set_key_equivalent( native_handle nMenuItem, native_handle key ) {
	
}

native_handle _chisel_native_menuitem_get_key_equivalent( native_handle nMenuItem ) {
	return NULL;
}

void _chisel_native_menuitem_set_key_equivalent_modifiers( native_handle nMenuItem, int modifiers ) {
	
}

int _chisel_native_menuitem_get_key_equivalent_modifiers( native_handle nMenuItem ) {
	return 0;
}

void _chisel_native_menuitem_set_image( native_handle nMenuItem, native_handle nImage ) {
    GtkWidget *menuitem = GTK_WIDGET(nMenuItem);
	GdkPixbuf *pixbuf = GDK_PIXBUF(nImage);
	
	GdkPixmap *pixmap;
	GdkBitmap *mask;
	gdk_pixbuf_render_pixmap_and_mask( pixbuf, &pixmap, &mask, 10 );
	
	assert( pixmap != NULL && mask != NULL );
	
	GtkWidget *image = gtk_image_new_from_pixmap( pixmap, mask );
	
	assert( image != NULL );
	
	gtk_widget_show( image );
	gtk_image_menu_item_set_image( GTK_IMAGE_MENU_ITEM(menuitem), image );
	gtk_image_menu_item_set_always_show_image( GTK_IMAGE_MENU_ITEM(menuitem), TRUE );
}

native_handle _chisel_native_menuitem_get_image( native_handle nMenuItem ) {
	return NULL;
}
