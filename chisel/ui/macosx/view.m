#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>

#include "view.h"

Rect NSRectToRect( NSRect inRect ) {
	Rect rect;
	
	rect.origin.x = inRect.origin.x;
	rect.origin.y = inRect.origin.y;
	rect.size.width = inRect.size.width;
	rect.size.height = inRect.size.height;
	
	return rect;
}

NSRect RectToNSRect( Rect inRect ) {
	NSRect rect;
	
	rect.origin.x = inRect.origin.x;
	rect.origin.y = inRect.origin.y;
	rect.size.width = inRect.size.width;
	rect.size.height = inRect.size.height;
	
	return rect;
}

@implementation ChiselView
- (BOOL)isFlipped {
	return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
	Rect rect = NSRectToRect( dirtyRect );
	
	_chisel_native_view_draw_rect_callback( self, rect );
}
@end

native_handle _chisel_native_view_create( ) {
	ChiselView *view = [[ChiselView alloc] init];
	assert( view != nil );
	
	return (native_handle)view;
}

void _chisel_native_view_add_subview( native_handle native, native_handle subview ) {
	NSView *pView = (NSView *)native;
	NSView *sView = (NSView *)subview;
	
	[pView addSubview: sView];
}

void _chisel_native_view_set_frame( native_handle native, Rect frame ) {
	NSView *pView = (NSView *)native;
	
	NSRect nsFrame;
	nsFrame.origin.x = frame.origin.x;
	nsFrame.origin.y = frame.origin.y;
	nsFrame.size.width = frame.size.width;
	nsFrame.size.height = frame.size.height;
	
	[pView setFrame: nsFrame];
}

Rect _chisel_native_view_get_frame( native_handle native ) {
	NSView *pView = (NSView *)native;
	NSRect rect = [pView frame];
	
	return NSRectToRect( rect );
}

void _chisel_native_view_invalidate_rect( native_handle native, Rect rect ) {
	NSView *pView = (NSView *)native;
	NSRect dirty = RectToNSRect( rect );
	
	[pView setNeedsDisplayInRect:dirty];
}
