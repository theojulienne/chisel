#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-menuItem.h>

enum {
	ModifierKeyShift=0x01,
	ModifierKeyAlternate=0x02,
	ModifierKeyCommand=0x04,
	ModifierKeyControl=0x08,
	
	ModifierKeyNativeDefault=0x10,
};



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

void _chisel_native_menuitem_set_key_equivalent( native_handle nMenuItem, native_handle key ) {
	NSMenuItem *menuItem = (NSMenuItem *)nMenuItem;
	NSString *keyEq = (NSString *)key;
	
	[menuItem setKeyEquivalent:keyEq];
}

native_handle _chisel_native_menuitem_get_key_equivalent( native_handle nMenuItem ) {
	NSMenuItem *menuItem = (NSMenuItem *)nMenuItem;
	
	return (native_handle)[menuItem keyEquivalent];
}

void _chisel_native_menuitem_set_key_equivalent_modifiers( native_handle nMenuItem, int modifiers ) {
	NSMenuItem *menuItem = (NSMenuItem *)nMenuItem;
	NSUInteger mask = 0;
	
	if ( (modifiers & ModifierKeyShift) != 0 ) {
		mask |= NSShiftKeyMask;
	}
	
	if ( (modifiers & ModifierKeyAlternate) != 0 ) {
		mask |= NSAlternateKeyMask;
	}
	
	// the native default modifier key on OS X is the command key
	if ( (modifiers & ModifierKeyCommand) != 0 || (modifiers & ModifierKeyNativeDefault) != 0 ) {
		mask |= NSCommandKeyMask;
	}
	
	if ( (modifiers & ModifierKeyControl) != 0 ) {
		mask |= NSControlKeyMask;
	}
	
	[menuItem setKeyEquivalentModifierMask:mask];
}

int _chisel_native_menuitem_get_key_equivalent_modifiers( native_handle nMenuItem ) {
	NSMenuItem *menuItem = (NSMenuItem *)nMenuItem;
	int modifiers = 0;
	NSUInteger mask = [menuItem keyEquivalentModifierMask];
	
	if ( (mask & NSShiftKeyMask) != 0 ) {
		modifiers |= ModifierKeyShift;
	}
	
	if ( (mask & NSAlternateKeyMask) != 0 ) {
		modifiers |= ModifierKeyAlternate;
	}
	
	if ( (mask & NSCommandKeyMask) != 0 ) {
		modifiers |= ModifierKeyCommand;
	}
	
	if ( (mask & NSControlKeyMask) != 0 ) {
		modifiers |= ModifierKeyControl;
	}
	
	return modifiers;
}

void _chisel_native_menuitem_set_image( native_handle nMenuItem, native_handle nImage ) {
	NSMenuItem *menuItem = (NSMenuItem *)nMenuItem;
	NSImage *image = (NSImage *)nImage;
	
	[menuItem setImage: image];
}

native_handle _chisel_native_menuitem_get_image( native_handle nMenuItem ) {
	NSMenuItem *menuItem = (NSMenuItem *)nMenuItem;
	
	return (native_handle)[menuItem image];
}
