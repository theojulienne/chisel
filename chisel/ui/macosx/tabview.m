#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-tabview.h>

native_handle _chisel_native_tabview_create( ) {
	NSTabView *tabview = [[NSTabView alloc] init];
	
	return (native_handle)tabview;
}

void _chisel_native_tabview_insert_item( native_handle native, uint index, native_handle nitem ) {
	NSTabView *tabview = (NSTabView *)native;
	NSTabViewItem *item = (NSTabViewItem *)nitem;
	
	[tabview insertTabViewItem:item atIndex:index];
}

void _chisel_native_tabview_remove_item( native_handle native, native_handle nitem ) {
	NSTabView *tabview = (NSTabView *)native;
	NSTabViewItem *item = (NSTabViewItem *)nitem;
	
	[tabview removeTabViewItem:item];
}

uint _chisel_native_tabview_item_count( native_handle native ) {
	NSTabView *tabview = (NSTabView *)native;
	
	return [tabview numberOfTabViewItems];
}

native_handle _chisel_native_tabview_item_get( native_handle native, uint index ) {
	NSTabView *tabview = (NSTabView *)native;
	
	return (native_handle)[tabview tabViewItemAtIndex:index];
}

void _chisel_native_tabview_select_item( native_handle native, native_handle nitem ) {
	NSTabView *tabview = (NSTabView *)native;
	NSTabViewItem *item = (NSTabViewItem *)nitem;
	
	[tabview selectTabViewItem:item];
}

native_handle _chisel_native_tabview_get_selected_item( native_handle native ) {
	NSTabView *tabview = (NSTabView *)native;
	
	return (native_handle)[tabview selectedTabViewItem];
}
