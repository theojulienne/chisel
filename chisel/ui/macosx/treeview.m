#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-treeview.h>

@interface ChiselTreeItem : NSObject
{
	object_handle _handle;
}

- (id)initWithHandle:(object_handle)handle;
- (object_handle)handle;
@end

@implementation ChiselTreeItem
- (id)initWithHandle:(object_handle)handle {
	_handle = handle;
	
	return self;
}

- (object_handle)handle {
	return _handle;
}
@end

@interface ChiselTreeDataSource : NSObject
{
	native_handle treeview;
}

- (id)initWithNative:(native_handle)handle;

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(ChiselTreeItem *)item;
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(ChiselTreeItem *)item;
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(ChiselTreeItem *)item;
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(ChiselTreeItem *)item;
@end

@implementation ChiselTreeDataSource
- (id)initWithNative:(native_handle)handle {
	treeview = handle;
	
	return self;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(ChiselTreeItem *)item {
	object_handle child = _chisel_native_treeview_child_at_index_callback( treeview, [item handle], index );
	
	return [[ChiselTreeItem alloc] initWithHandle:child];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(ChiselTreeItem *)item {
	return _chisel_native_treeview_item_expandable_callback( treeview, [item handle] );
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(ChiselTreeItem *)item {
	return _chisel_native_treeview_child_count_callback( treeview, [item handle] );
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(ChiselTreeItem *)item {
	return (id)_chisel_native_treeview_value_for_column_callback( treeview, [item handle], (native_handle)tableColumn );
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
