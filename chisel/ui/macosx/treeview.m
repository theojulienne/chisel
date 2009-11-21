#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-treeview.h>

#include "../../core/macosx/wrapped.h"

@interface ChiselTreeDataSource : NSObject
{
	native_handle treeview;
}

- (id)initWithNative:(native_handle)handle;

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(ChiselWrappedObject *)item;
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(ChiselWrappedObject *)item;
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(ChiselWrappedObject *)item;
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(ChiselWrappedObject *)item;

- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
@end

@implementation ChiselTreeDataSource
- (id)initWithNative:(native_handle)handle {
	treeview = handle;
	
	return self;
}

// data source methods

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(ChiselWrappedObject *)item {
	return (ChiselWrappedObject *)_chisel_native_treeview_child_at_index_callback( treeview, (native_handle)item, index );
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(ChiselWrappedObject *)item {
	return _chisel_native_treeview_item_expandable_callback( treeview, (native_handle)item );
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(ChiselWrappedObject *)item {
	return _chisel_native_treeview_child_count_callback( treeview, (native_handle)item );
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(ChiselWrappedObject *)item {
	return (id)_chisel_native_treeview_value_for_column_callback( treeview, (native_handle)item, (native_handle)tableColumn );
}

// delegate methods

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
	_chisel_native_treeview_selection_changed_callback( treeview );
}
@end

native_handle _chisel_native_treeview_create( ) {
	NSOutlineView *treeView = [[NSOutlineView alloc] init];
	NSScrollView *scrollView = [[NSScrollView alloc] init];
	
	[scrollView setDocumentView: treeView];
	[scrollView setHasVerticalScroller:YES];
	[scrollView setHasHorizontalScroller:YES];
	[scrollView setAutohidesScrollers:YES];
	
	return (native_handle)scrollView;
}

void _chisel_native_treeview_prepare( native_handle native ) {
	NSScrollView *scrollView = (NSScrollView *)native;
	NSOutlineView *treeView = (NSOutlineView *)[scrollView documentView];
	
	ChiselTreeDataSource *dataSource = [[ChiselTreeDataSource alloc] initWithNative:native];
	
	[treeView setDataSource:dataSource];
	[treeView setDelegate:dataSource];
}

void _chisel_native_treeview_reload( native_handle native ) {
	NSScrollView *scrollView = (NSScrollView *)native;
	NSOutlineView *treeView = (NSOutlineView *)[scrollView documentView];
	
	[treeView reloadItem:nil reloadChildren:YES];
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

void _chisel_native_treeview_set_outline_column( native_handle ntreeview, native_handle ncolumn ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	NSTableColumn *column = (NSTableColumn *)ncolumn;
	
	[treeview setOutlineTableColumn:column];
}

native_handle _chisel_native_treeview_get_outline_column( native_handle ntreeview ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	
	return (native_handle)[treeview outlineTableColumn];
}

void _chisel_native_treeview_set_multiple_selection( native_handle ntreeview, int flag ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	
	[treeview setAllowsMultipleSelection:flag];
}

int _chisel_native_treeview_get_multiple_selection( native_handle ntreeview ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	
	return [treeview allowsMultipleSelection];
}

void _chisel_native_treeview_set_empty_selection( native_handle ntreeview, int flag ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	
	[treeview setAllowsEmptySelection:flag];
}

int _chisel_native_treeview_get_empty_selection( native_handle ntreeview ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	
	return [treeview allowsEmptySelection];
}

native_handle _chisel_native_treeview_get_selected_rows( native_handle ntreeview ) {
	NSScrollView *scrollView = (NSScrollView *)ntreeview;
	NSOutlineView *treeview = (NSOutlineView *)[scrollView documentView];
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	NSIndexSet *selectedIndexes = [treeview selectedRowIndexes];
	int numIndexes = [selectedIndexes count];
	
	NSUInteger *selectedIndexesRaw = (NSUInteger *)malloc( sizeof(NSUInteger) * numIndexes );
	
	numIndexes = [selectedIndexes getIndexes:selectedIndexesRaw maxCount:numIndexes inIndexRange:nil];
	
	int i;
	for ( i = 0; i < numIndexes; i++ ) {
		int idx = selectedIndexesRaw[i];
		ChiselWrappedObject *cwo = (ChiselWrappedObject *)[treeview itemAtRow: idx];
	
		[arr addObject: cwo];
	}
	
	free( selectedIndexesRaw );

	return (native_handle)arr;
}
