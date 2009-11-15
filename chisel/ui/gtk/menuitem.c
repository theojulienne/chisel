#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-menuitem.h>

enum {
	ModifierKeyShift=0x01,
	ModifierKeyAlternate=0x02,
	ModifierKeyCommand=0x04,
	ModifierKeyControl=0x08,
	
	ModifierKeyNativeDefault=0x10,
};

native_handle _chisel_native_menuitem_create( ) {
	return NULL;
}

native_handle _chisel_native_menuitem_create_separator( ) {
	return NULL;
}

void _chisel_native_menuitem_set_submenu( native_handle nmenuItem, native_handle nsubmenu ) {
	
}

native_handle _chisel_native_menuitem_get_submenu( native_handle nmenuItem ) {
	return NULL;
}

void _chisel_native_menuitem_set_enabled( native_handle nmenuItem, int flag ) {
	
}

int _chisel_native_menuitem_get_enabled( native_handle nmenuItem ) {
	return 0;
}

void _chisel_native_menuitem_set_visible( native_handle nmenuItem, int flag ) {
	
}

int _chisel_native_menuitem_get_visible( native_handle nmenuItem ) {
	return 0;
}

void _chisel_native_menuitem_set_title( native_handle nmenuItem, native_handle ntitle ) {
	
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
	
}

native_handle _chisel_native_menuitem_get_image( native_handle nMenuItem ) {
	return NULL;
}
