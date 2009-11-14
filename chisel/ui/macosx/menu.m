#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-menu.h>

native_handle _chisel_native_menu_create( ) {
	NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
	
	return (native_handle)menu;
}

void _chisel_native_menu_insert_item( native_handle nmenu, uint index, native_handle nitem ) {
	NSMenu *menu = (NSMenu *)nmenu;
	NSMenuItem *menuitem = (NSMenuItem *)nitem;
	
	[menu insertItem:menuitem atIndex:index];
}

uint _chisel_native_menu_item_count( native_handle nmenu ) {
	NSMenu *menu = (NSMenu *)nmenu;
	
	return [menu numberOfItems];
}

native_handle _chisel_native_menu_item_get( native_handle nmenu, uint index ) {
	NSMenu *menu = (NSMenu *)nmenu;
	
	return (native_handle)[menu itemAtIndex:index];
}
