#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-frame.h>

#include "view.h"

native_handle _chisel_native_frame_create( ) {
	NSRect frameRect = NSMakeRect( 10, 10, 100, 100 ); // FIXME: rect somewhere

	NSBox *frame = [[NSBox alloc] init];
	assert( frame != nil );
	
	[frame setContentView: [[ChiselView alloc] init]];

	return (native_handle)frame;
}

void _chisel_native_frame_set_title( native_handle native, native_handle str ) {
	NSBox *frame = (NSBox *)native;
	
	NSString *newTitle = (NSString *)str;
	
	[frame setTitle:newTitle];
}

native_handle _chisel_native_frame_get_content_view( native_handle native ) {
	NSBox *frame = (NSBox *)native;
	
	return (native_handle)[frame contentView];
}

void _chisel_native_frame_set_content_view( native_handle native, native_handle nview ) {
	NSBox *frame = (NSBox *)native;
	ChiselView *view = (ChiselView *)nview;
	
	[frame setContentView: view];
}
