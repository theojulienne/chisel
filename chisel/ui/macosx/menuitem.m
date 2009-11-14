#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-menuItem.h>

@interface ChiselMenuItem : NSMenuItem
- (void)onPress;
@end

@implementation ChiselMenuItem
- (void)onPress {
	_chisel_native_menuitem_pressed_callback( self );
}
@end

native_handle _chisel_native_menuitem_create( ) {
	NSMenuItem *menuItem = [[ChiselMenuItem alloc] init];
	
	[menuItem setTarget: menuItem];
	[menuItem setAction: @selector(onPress)];
	
	[menuItem setEnabled:YES];
	[menuItem setHidden:NO];
	
	return (native_handle)menuItem;
}

native_handle _chisel_native_menuitem_create_separator( ) {
	return (native_handle)[NSMenuItem separatorItem];
}

void _chisel_native_menuitem_set_submenu( native_handle nmenuItem, native_handle nsubmenu ) {
	NSMenuItem *menuItem = (NSMenuItem *)nmenuItem;
	NSMenu *submenu = (NSMenu *)nsubmenu;
	
	[menuItem setSubmenu: submenu];
}

native_handle _chisel_native_menuitem_get_submenu( native_handle nmenuItem ) {
	NSMenuItem *menuItem = (NSMenuItem *)nmenuItem;
	
	return (native_handle)[menuItem submenu];
}

void _chisel_native_menuitem_set_enabled( native_handle nmenuItem, int flag ) {
	NSMenuItem *menuItem = (NSMenuItem *)nmenuItem;
	
	[menuItem setEnabled: flag ? YES : NO];
}

int _chisel_native_menuitem_get_enabled( native_handle nmenuItem ) {
	NSMenuItem *menuItem = (NSMenuItem *)nmenuItem;
	
	return [menuItem isEnabled];
}

void _chisel_native_menuitem_set_visible( native_handle nmenuItem, int flag ) {
	NSMenuItem *menuItem = (NSMenuItem *)nmenuItem;
	
	[menuItem setHidden: flag ? NO : YES];
}

int _chisel_native_menuitem_get_visible( native_handle nmenuItem ) {
	NSMenuItem *menuItem = (NSMenuItem *)nmenuItem;
	
	return ![menuItem isHidden];
}

void _chisel_native_menuitem_set_title( native_handle nmenuItem, native_handle ntitle ) {
	NSMenuItem *menuItem = (NSMenuItem *)nmenuItem;
	NSString *title = (NSString *)ntitle;
	
	[menuItem setTitle:title];
}

native_handle _chisel_native_menuitem_get_title( native_handle nmenuItem ) {
	NSMenuItem *menuItem = (NSMenuItem *)nmenuItem;
	
	return (native_handle)[menuItem title];
}

