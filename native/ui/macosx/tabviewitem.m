#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-tabview.h>

native_handle _chisel_native_tabviewitem_create( ) {
	NSTabViewItem *tabviewitem = [[NSTabViewItem alloc] initWithIdentifier: nil];
	
	return (native_handle)tabviewitem;
}

void _chisel_native_tabviewitem_set_title( native_handle nitem, native_handle ntitle ) {
	NSTabViewItem *tabviewitem = (NSTabViewItem *)nitem;
	NSString *title = (NSString *)ntitle;
	
	[tabviewitem setLabel:title];
}

native_handle _chisel_native_tabviewitem_get_title( native_handle nitem ) {
	NSTabViewItem *tabviewitem = (NSTabViewItem *)nitem;
	
	return [tabviewitem label];
}

native_handle _chisel_native_tabviewitem_get_content_view( native_handle nitem ) {
	NSTabViewItem *tabviewitem = (NSTabViewItem *)nitem;
	
	return (native_handle)[tabviewitem view];
}

void _chisel_native_tabviewitem_set_content_view( native_handle nitem, native_handle nview ) {
	NSTabViewItem *tabviewitem = (NSTabViewItem *)nitem;
	NSView *view = (NSView *)nview;
	
	[tabviewitem setView:view];
}
