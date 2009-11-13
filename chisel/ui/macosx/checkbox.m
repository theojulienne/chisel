#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-checkbox.h>

@interface ChiselCheckBox : NSButton
- (id)initWithFrame:(NSRect)frameRect;
- (void)checkboxPressed:(NSButton *)checkbox;
@end

@implementation ChiselCheckBox
- (id)initWithFrame:(NSRect)frameRect {
	id res = [super initWithFrame:frameRect];
	
	[res setTarget:res];
	[res setAction:@selector(checkboxPressed:)];
	
	return res;
}

- (void)checkboxPressed:(NSButton *)checkbox {
	_chisel_native_checkbox_changed_callback( self );
}
@end

native_handle _chisel_native_checkbox_create( ) {
	NSButton *view = [[ChiselCheckBox alloc] init];
	assert( view != nil );
	
	[view setButtonType:NSSwitchButton];
	[view setBordered:NO];
	
	return (native_handle)view;
}

void _chisel_native_checkbox_set_enabled( native_handle native, int val ) {
	NSButton *checkbox = (NSButton *)native;
	
	[checkbox setEnabled: val == 0 ? NO : YES];
}

int _chisel_native_checkbox_get_enabled( native_handle native ) {
	NSButton *checkbox = (NSButton *)native;
	
	return [checkbox isEnabled] ? 1 : 0;
}

void _chisel_native_checkbox_set_checked( native_handle native, int val ) {
	NSButton *checkbox = (NSButton *)native;
	
	[checkbox setState: val == 0 ? NSOffState : NSOnState];
}

int _chisel_native_checkbox_get_checked( native_handle native ) {
	NSButton *checkbox = (NSButton *)native;
	
	return [checkbox state] == NSOnState ? 1 : 0;
}

void _chisel_native_checkbox_set_text( native_handle native, native_handle s ) {
	NSButton *checkbox = (NSButton *)native;
	NSString *str = (NSString *)s;
	
	[checkbox setTitle: str];
}

CLFloat _chisel_native_checkbox_get_height( native_handle native ) {
	NSButton *checkbox = (NSButton *)native;
	NSButtonCell *cell = [checkbox cell];
	NSSize cellSize = [cell cellSize];
	
	return cellSize.height;
}
