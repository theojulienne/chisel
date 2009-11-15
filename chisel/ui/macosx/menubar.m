#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-menubar.h>
#include <chisel-native-menu.h>

#include "menus.h"
#include "../../core/macosx/application.h"

@implementation ChiselMenuBar
- (ChiselMenuBar *)initWithTitle:(NSString *)title {
	[super initWithTitle:title];
	
	ChiselApplicationDelegate *ad = (ChiselApplicationDelegate *)[NSApp delegate];

	NSMenuItem *item = [ad createAppleMenuItem];

	[self addItem: item];

	return self;
}

- (void)chiselInsertItem:(NSMenuItem *)item atIndex:(uint)index {
	[self insertItem:item atIndex:index+1];
}

- (uint)chiselNumberOfItems {
	return [self numberOfItems] - 1;
}

- (NSMenuItem *)chiselItemAtIndex:(uint)index {
	return [self itemAtIndex: index+1];
}
@end



native_handle _chisel_native_menubar_create( ) {
	ChiselMenuBar *menu = [[ChiselMenuBar alloc] initWithTitle:@""];
	
	return (native_handle)menu;
}
