#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-menuitem.h>

native_handle _chisel_native_menuitem_create( ) {
	NSMenuItem *menuitem = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
	
	[menuitem setEnabled:YES];
	
	return (native_handle)menuitem;
}

native_handle _chisel_native_menuitem_create_separator( ) {
	return (native_handle)[NSMenuItem separatorItem];
}

void _chisel_native_menuitem_set_submenu( native_handle nmenuitem, native_handle nsubmenu ) {
	NSMenuItem *menuitem = (NSMenuItem *)nmenuitem;
	NSMenu *submenu = (NSMenu *)nsubmenu;
	
	[menuitem setSubmenu: submenu];
}

native_handle _chisel_native_menuitem_get_submenu( native_handle nmenuitem ) {
	NSMenuItem *menuitem = (NSMenuItem *)nmenuitem;
	
	return (native_handle)[menuitem submenu];
}

void _chisel_native_menuitem_set_enabled( native_handle nmenuitem, int flag ) {
	NSMenuItem *menuitem = (NSMenuItem *)nmenuitem;
	
	[menuitem setEnabled: flag ? YES : NO];
}

int _chisel_native_menuitem_get_enabled( native_handle nmenuitem ) {
	NSMenuItem *menuitem = (NSMenuItem *)nmenuitem;
	
	return [menuitem isEnabled];
}

void _chisel_native_menuitem_set_visible( native_handle nmenuitem, int flag ) {
	NSMenuItem *menuitem = (NSMenuItem *)nmenuitem;
	
	[menuitem setHidden: flag ? NO : YES];
}

int _chisel_native_menuitem_get_visible( native_handle nmenuitem ) {
	NSMenuItem *menuitem = (NSMenuItem *)nmenuitem;
	
	return ![menuitem isHidden];
}

void _chisel_native_menuitem_set_title( native_handle nmenuitem, native_handle ntitle ) {
	NSMenuItem *menuitem = (NSMenuItem *)nmenuitem;
	NSString *title = (NSString *)ntitle;
	
	[menuitem setTitle:title];
}

native_handle _chisel_native_menuitem_get_title( native_handle nmenuitem ) {
	NSMenuItem *menuitem = (NSMenuItem *)nmenuitem;
	
	return (native_handle)[menuitem title];
}

