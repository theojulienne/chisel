#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-label.h>

native_handle _chisel_native_label_create( ) {
	NSTextField *view = [[NSTextField alloc] init];
	assert( view != nil );
	
	[view setEditable:NO];
	[view setBezeled:NO];
	[view setDrawsBackground:NO];
	
	return (native_handle)view;
}

void _chisel_native_label_set_selectable( native_handle native, int val ) {
	NSTextField *label = (NSTextField *)native;
	
	[label setSelectable: val == 0 ? NO : YES];
}

int _chisel_native_label_get_selectable( native_handle native ) {
	NSTextField *label = (NSTextField *)native;
	
	return [label isSelectable] == YES ? 1 : 0;
}

void _chisel_native_label_set_text( native_handle native, native_handle s ) {
	NSTextField *label = (NSTextField *)native;
	NSString *str = (NSString *)s;
	
	[label setStringValue: str];
}

CLFloat _chisel_native_label_get_height( native_handle native ) {
	NSTextField *label = (NSTextField *)native;
	NSTextFieldCell *cell = [label cell];
	NSSize cellSize = [cell cellSize];
	
	return cellSize.height;
}