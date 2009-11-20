#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-treeview.h>

native_handle _chisel_native_treeview_create( ) {
	NSOutlineView *treeView = [[NSOutlineView alloc] init];
	NSScrollView *scrollView = [[NSScrollView alloc] init];
	
	[scrollView setDocumentView: treeView];
	
	return (native_handle)scrollView;
}

void _chisel_native_treeview_add_column( native_handle ntreeview, native_handle ncolumn ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	NSTableColumn *column = (NSTableColumn *)ncolumn;
	
	[treeview addTableColumn:column];
}

void _chisel_native_treeview_remove_column( native_handle ntreeview, native_handle ncolumn ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	NSTableColumn *column = (NSTableColumn *)ncolumn;
	
	[treeview removeTableColumn:column];
}

void _chisel_native_treeview_set_reorder_columns( native_handle ntreeview, int flag ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	
	[treeview setAllowsColumnReordering:flag];
}

int _chisel_native_treeview_get_reorder_columns( native_handle ntreeview ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	
	return [treeview allowsColumnReordering];
}

void _chisel_native_treeview_set_resize_columns( native_handle ntreeview, int flag ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	
	[treeview setAllowsColumnResizing:flag];
}

int _chisel_native_treeview_get_resize_columns( native_handle ntreeview ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	
	return [treeview allowsColumnResizing];
}
