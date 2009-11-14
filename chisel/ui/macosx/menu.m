#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-menu.h>

#include "menus.h"

@implementation ChiselMenu
- (void)chiselInsertItem:(NSMenuItem *)item atIndex:(uint)index {
	[self insertItem:item atIndex:index];
	[self update];
}

- (uint)chiselNumberOfItems {
	return [self numberOfItems];
}

- (NSMenuItem *)chiselItemAtIndex:(uint)index {
	return [self itemAtIndex: index];
}

- (NSString *)title {
	NSMenu *supermenu = [self supermenu];
	
	if ( supermenu == nil ) {
		return [super title];
	}
	
	int myItemIndex = [supermenu indexOfItemWithSubmenu: self];
	if ( myItemIndex == -1 ) {
		return [super title];
	}
	
	NSMenuItem *myItem = [supermenu itemAtIndex:myItemIndex];
	if ( myItem == nil ) {
		return [super title];
	}
	
	return [myItem title];
}
@end

native_handle _chisel_native_menu_create( ) {
	ChiselMenu *menu = [[ChiselMenu alloc] initWithTitle:@""];
	
	return (native_handle)menu;
}

void _chisel_native_menu_insert_item( native_handle nmenu, uint index, native_handle nitem ) {
	ChiselMenu *menu = (ChiselMenu *)nmenu;
	NSMenuItem *menuitem = (NSMenuItem *)nitem;
	
	[menu chiselInsertItem:menuitem atIndex:index];
}

uint _chisel_native_menu_item_count( native_handle nmenu ) {
	ChiselMenu *menu = (ChiselMenu *)nmenu;
	
	return [menu chiselNumberOfItems];
}

native_handle _chisel_native_menu_item_get( native_handle nmenu, uint index ) {
	ChiselMenu *menu = (ChiselMenu *)nmenu;
	
	return (native_handle)[menu chiselItemAtIndex:index];
}
