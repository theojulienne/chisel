#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-progressbar.h>

@interface ChiselProgressIndicator : NSProgressIndicator
{
	bool _isAnimating;
}
- (id)initWithFrame:(NSRect)frameRect;
- (void)startAnimation:(id)sender;
- (void)stopAnimation:(id)sender;
- (bool)isAnimating;
@end

@implementation ChiselProgressIndicator
- (id)initWithFrame:(NSRect)frameRect {
	id res = [super initWithFrame:frameRect];
	
	_isAnimating = NO;
	
	return res;
}

- (void)startAnimation:(id)sender {
	if ( !_isAnimating ) {
		_isAnimating = YES;
		[super startAnimation: sender];
	}
}

- (void)stopAnimation:(id)sender {
	if ( _isAnimating ) {
		_isAnimating = NO;
		[super stopAnimation: sender];
	}
}

- (bool)isAnimating {
	return _isAnimating;
}
@end

native_handle _chisel_native_progressbar_create( int direction ) {
	NSProgressIndicator *view = [[ChiselProgressIndicator alloc] init];
	assert( view != nil );
	
	return (native_handle)view;
}

void _chisel_native_progressbar_set_minimum( native_handle native, CLFloat minValue ) {
	NSProgressIndicator *progressbar = (NSProgressIndicator *)native;
	
	[progressbar setMinValue:minValue];
	
	[progressbar displayIfNeeded];
}

void _chisel_native_progressbar_set_maximum( native_handle native, CLFloat maxValue ) {
	NSProgressIndicator *progressbar = (NSProgressIndicator *)native;
	
	[progressbar setMaxValue:maxValue];
	
	[progressbar displayIfNeeded];
}

void _chisel_native_progressbar_set_value( native_handle native, CLFloat value ) {
	NSProgressIndicator *progressbar = (NSProgressIndicator *)native;
	
	double oldVal = [progressbar doubleValue];
	if ( oldVal == [progressbar minValue] || oldVal == [progressbar maxValue] ) {
		[progressbar setIndeterminate: YES];
		[progressbar setIndeterminate: NO];
	}
	
	[progressbar setDoubleValue: value];
	
	[progressbar displayIfNeeded];
}

CLFloat _chisel_native_progressbar_get_value( native_handle native ) {
	NSProgressIndicator *progressbar = (NSProgressIndicator *)native;
	
	return [progressbar doubleValue];
}

CLFloat _chisel_native_progressbar_get_thickness( native_handle native ) {
	return (CLFloat)NSProgressIndicatorPreferredThickness;
}

void _chisel_native_progressbar_set_indeterminate( native_handle native, int val ) {
	NSProgressIndicator *progressbar = (NSProgressIndicator *)native;
	
	[progressbar setIndeterminate: val == 0 ? NO : YES];
	
	[progressbar displayIfNeeded];
}

int _chisel_native_progressbar_get_indeterminate( native_handle native ) {
	NSProgressIndicator *progressbar = (NSProgressIndicator *)native;
	
	return [progressbar isIndeterminate] ? 1 : 0;
}

void _chisel_native_progressbar_set_animating( native_handle native, int val ) {
	NSProgressIndicator *progressbar = (NSProgressIndicator *)native;
	
	if ( val ) {
		[progressbar startAnimation: progressbar];
	} else {
		[progressbar stopAnimation: progressbar];
	}
	
	[progressbar displayIfNeeded];
}

int _chisel_native_progressbar_get_animating( native_handle native ) {
	ChiselProgressIndicator *progressbar = (ChiselProgressIndicator *)native;
	
	return [progressbar isAnimating] ? 1 : 0;
}
