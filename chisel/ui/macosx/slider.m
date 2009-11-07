#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-slider.h>

native_handle _chisel_native_slider_create( ) {
	NSSlider *view = [[NSSlider alloc] init];
	assert( view != nil );
	
	return (native_handle)view;
}

void _chisel_native_slider_set_vertical( native_handle native, int vertical ) {
	NSSplitView *view = (NSSplitView *)native;
	
	[view setVertical: vertical ? YES : NO];
}

int _chisel_native_slider_get_vertical( native_handle native ) {
	NSSplitView *view = (NSSplitView *)native;
	
	return [view isVertical] ? 1 : 0;
}

