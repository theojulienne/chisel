#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-splitview.h>

#include <chisel-native-enums.h>

native_handle _chisel_native_splitview_create( int direction ) {
	NSSplitView *view = [[NSSplitView alloc] initWithFrame:NSMakeRect( 0, 0, 1, 1 )];
	assert( view != nil );
	
	if ( direction == SpitterStackingHorizontal ) {
		[view setVertical: NO];
	} else {
		[view setVertical: YES];
	}
	
	return (native_handle)view;
}
/*
void _chisel_native_splitview_set_vertical( native_handle native, int vertical ) {
	NSSplitView *view = (NSSplitView *)native;
	
	[view setVertical: vertical ? YES : NO];
}

int _chisel_native_splitview_get_vertical( native_handle native ) {
	NSSplitView *view = (NSSplitView *)native;
	
	return [view isVertical] ? 1 : 0;
}
*/
void _chisel_native_splitview_set_divider_position( native_handle native, int index, CLFloat position ) {
	NSSplitView *view = (NSSplitView *)native;
	
	[view setPosition:position ofDividerAtIndex:index];
}
