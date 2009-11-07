#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-window.h>

#include "view.h"

@interface ChiselWindow : NSWindow {
}

- (void)windowWillClose:(NSNotification *)notification;
@end

@implementation ChiselWindow
- (void)windowWillClose:(NSNotification *)notification {
	_chisel_native_window_will_close_callback( self );
}
@end

native_handle _chisel_native_window_create( ) {
	NSRect windowRect = NSMakeRect( 10, 10, 100, 100 ); // FIXME: rect somewhere

	ChiselWindow *window = [[ChiselWindow alloc] initWithContentRect:windowRect 
	styleMask:( NSResizableWindowMask | NSClosableWindowMask | NSTitledWindowMask) 
	backing:NSBackingStoreBuffered defer:NO];
	assert( window != nil );
	
	[window setContentView: [[ChiselView alloc] init]];
	[window setDelegate: window];

	return (native_handle)window;
}

void _chisel_native_window_set_title( native_handle native, native_handle str ) {
	ChiselWindow *window = (ChiselWindow *)native;
	
	NSString *newTitle = (NSString *)str;
	
	[window setTitle:newTitle];
}

void _chisel_native_window_set_content_size( native_handle native, Size size ) {
	ChiselWindow *window = (ChiselWindow *)native;
	
	NSSize windowRect = NSMakeSize( size.width, size.height );
	
	[window setContentSize:windowRect];
}

void _chisel_native_window_set_visible( native_handle native, int visibility ) {
	ChiselWindow *window = (ChiselWindow *)native;
	
	if ( visibility ) {
		[window makeKeyAndOrderFront:nil];
	}
}

native_handle _chisel_native_window_get_content_view( native_handle native ) {
	ChiselWindow *window = (ChiselWindow *)native;
	
	return (native_handle)[window contentView];
}

void _chisel_native_window_set_content_view( native_handle native, native_handle nview ) {
	ChiselWindow *window = (ChiselWindow *)native;
	ChiselView *view = (ChiselView *)nview;
	
	[window setContentView: view];
}

void _chisel_native_window_close( native_handle native ) {
	ChiselWindow *window = (ChiselWindow *)native;
	[window close];
}