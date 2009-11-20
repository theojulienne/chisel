module chisel.ui.treeview;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;
import chisel.ui.tablecolumn;

extern (C) {
	native_handle _chisel_native_treeview_create( );
	
	void _chisel_native_treeview_set_reorder_columns( native_handle treeview, int flag );
	int _chisel_native_treeview_get_reorder_columns( native_handle treeview );
	
	void _chisel_native_treeview_set_resize_columns( native_handle treeview, int flag );
	int _chisel_native_treeview_get_resize_columns( native_handle treeview );
	
	void _chisel_native_treeview_add_column( native_handle treeview, native_handle column );
	void _chisel_native_treeview_remove_column( native_handle treeview, native_handle column );
}

interface TreeViewDataSource {
	uint numberOfChildrenOfItem( TreeView treeView, Object item );
	bool isItemExpandable( TreeView treeView, Object item );
	Object childAtIndex( TreeView treeView, Object parent, uint index );
	CObject valueForTableColumn( TreeView treeView, Object item, TableColumn column );
}

class TreeView : View {
	TreeViewDataSource dataSource;
	
	this( ) {
		super( );
		native = _chisel_native_treeview_create( );
	}
	
	this( Rect frame ) {
		this( );
		this.frame = frame;
	}
	
	void addTableColumn( TableColumn column ) {
		_chisel_native_treeview_add_column( native, column.native );
	}
	
	void removeTableColumn( TableColumn column ) {
		_chisel_native_treeview_remove_column( native, column.native );
	}
	
	void allowsColumnReordering( bool val ) {
		_chisel_native_treeview_set_reorder_columns( native, val?1:0 );
	}
	
	bool allowsColumnReordering( ) {
		return _chisel_native_treeview_get_reorder_columns( native ) != 0;
	}
	
	void allowsColumnResizing( bool val ) {
		_chisel_native_treeview_set_resize_columns( native, val?1:0 );
	}
	
	bool allowsColumnResizing( ) {
		return _chisel_native_treeview_get_resize_columns( native ) != 0;
	}
}
