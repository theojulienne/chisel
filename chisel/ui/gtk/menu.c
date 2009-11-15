#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-menu.h>

native_handle _chisel_native_menu_create( ) {
	return NULL;
}

void _chisel_native_menu_insert_item( native_handle nmenu, uint index, native_handle nitem ) {
	
}

uint _chisel_native_menu_item_count( native_handle nmenu ) {
	return 0;
}

native_handle _chisel_native_menu_item_get( native_handle nmenu, uint index ) {
	return NULL;
}
