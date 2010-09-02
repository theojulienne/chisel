#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-button.h>

@interface ChiselButton : NSButton
- (id)initWithFrame:(NSRect)frameRect;
- (void)buttonPressed:(NSButton *)button;
@end

@implementation ChiselButton
- (id)initWithFrame:(NSRect)frameRect {
	id res = [super initWithFrame:frameRect];
	
	[res setTarget:res];
	[res setAction:@selector(buttonPressed:)];
	
	return res;
}

- (void)buttonPressed:(NSButton *)button {
	_chisel_native_button_pressed_callback( self );
}
@end

native_handle _chisel_native_button_create( ) {
	NSButton *view = [[ChiselButton alloc] init];
	assert( view != nil );
	
	[view setButtonType:NSMomentaryPushInButton];
	[view setBordered:YES];
	[view setBezelStyle:NSRoundedBezelStyle];
	[view setImagePosition:NSNoImage];
	[view setAlignment:NSCenterTextAlignment];
	
	return (native_handle)view;
}

void _chisel_native_button_set_enabled( native_handle native, int val ) {
	NSButton *button = (NSButton *)native;
	
	[button setEnabled: val == 0 ? NO : YES];
}

int _chisel_native_button_get_enabled( native_handle native ) {
	NSButton *button = (NSButton *)native;
	
	return [button isEnabled] ? 1 : 0;
}

void _chisel_native_button_set_text( native_handle native, native_handle s ) {
	NSButton *button = (NSButton *)native;
	NSString *str = (NSString *)s;
	
	[button setTitle: str];
}

CLFloat _chisel_native_button_get_height( native_handle native ) {
	NSButton *button = (NSButton *)native;
	NSButtonCell *cell = [button cell];
	NSSize cellSize = [cell cellSize];
	
	return cellSize.height;
}