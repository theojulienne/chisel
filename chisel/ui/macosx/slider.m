#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-slider.h>

@interface ChiselSlider : NSSlider
- (id)initWithFrame:(NSRect)frameRect;
- (void)sliderValueChanged:(NSSlider *)slider;
@end

@implementation ChiselSlider
- (id)initWithFrame:(NSRect)frameRect {
	id res = [super initWithFrame:frameRect];
	
	[res setTarget:res];
	[res setAction:@selector(sliderValueChanged:)];
	
	return res;
}

- (void)sliderValueChanged:(NSSlider *)slider {
	_chisel_native_slider_changed_callback( self );
}
@end

native_handle _chisel_native_slider_create( ) {
	NSSlider *view = [[ChiselSlider alloc] init];
	assert( view != nil );
	
	return (native_handle)view;
}

void _chisel_native_slider_set_minimum( native_handle native, CLFloat minValue ) {
	NSSlider *slider = (NSSlider *)native;
	
	[slider setMinValue:minValue];
}

void _chisel_native_slider_set_maximum( native_handle native, CLFloat maxValue ) {
	NSSlider *slider = (NSSlider *)native;
	
	[slider setMaxValue:maxValue];
}

void _chisel_native_slider_set_value( native_handle native, CLFloat value ) {
	NSSlider *slider = (NSSlider *)native;
	
	[slider setDoubleValue: value];
}

CLFloat _chisel_native_slider_get_value( native_handle native ) {
	NSSlider *slider = (NSSlider *)native;
	
	return [slider doubleValue];
}
