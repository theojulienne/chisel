module chisel.ui.treeview;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;
import chisel.ui.tablecolumn;

extern (C) {
	native_handle _chisel_native_treeview_create( );
	
	void _chisel_native_treeview_prepare( native_handle native );
	void _chisel_native_treeview_reload( native_handle native );
	
	void _chisel_native_treeview_set_reorder_columns( native_handle treeview, int flag );
	int _chisel_native_treeview_get_reorder_columns( native_handle treeview );
	
	void _chisel_native_treeview_set_resize_columns( native_handle treeview, int flag );
	int _chisel_native_treeview_get_resize_columns( native_handle treeview );
	
	void _chisel_native_treeview_set_multiple_selection( native_handle treeview, int flag );
	int _chisel_native_treeview_get_multiple_selection( native_handle treeview );
	
	void _chisel_native_treeview_set_empty_selection( native_handle treeview, int flag );
	int _chisel_native_treeview_get_empty_selection( native_handle treeview );
	
	void _chisel_native_treeview_add_column( native_handle treeview, native_handle column );
	void _chisel_native_treeview_remove_column( native_handle treeview, native_handle column );
	
	void _chisel_native_treeview_set_outline_column( native_handle treeview, native_handle column );
	native_handle _chisel_native_treeview_get_outline_column( native_handle treeview );
	
	native_handle _chisel_native_treeview_get_selected_rows( native_handle treeview );
	
	void _chisel_native_treeview_selection_changed_callback( native_handle native ) {
		TreeView treeView = cast(TreeView)NativeBridge.forNative( native );
		assert( treeView !is null );
		
		treeView.selectionChanged( );
	}
	
	uint _chisel_native_treeview_child_count_callback( native_handle treeview, native_handle item ) {
		TreeView treeView = cast(TreeView)NativeBridge.forNative( treeview );
		assert( treeView !is null );
		
		WrappedObject treeItem = null;
		if ( item !is null ) {
			treeItem = cast(WrappedObject)NativeBridge.forNative( item );
		}
		
		Object itemObject = (treeItem is null) ? null : treeItem.object;
		
		TreeViewDataSource dataSource = treeView.dataSource;
		if ( dataSource is null )
			return 0;
		
		return dataSource.numberOfChildrenOfItem( treeView, itemObject );
	}
	
	uint _chisel_native_treeview_item_expandable_callback( native_handle treeview, native_handle item ) {
		TreeView treeView = cast(TreeView)NativeBridge.forNative( treeview );
		assert( treeView !is null );
		
		WrappedObject treeItem = null;
		if ( item !is null ) {
			treeItem = cast(WrappedObject)NativeBridge.forNative( item );
		}
		
		Object itemObject = (treeItem is null) ? null : treeItem.object;
		
		TreeViewDataSource dataSource = treeView.dataSource;
		if ( dataSource is null )
			return 0;
		
		return dataSource.isItemExpandable( treeView, itemObject );
	}
	
	native_handle _chisel_native_treeview_child_at_index_callback( native_handle treeview, native_handle item, uint index ) {
		TreeView treeView = cast(TreeView)NativeBridge.forNative( treeview );
		assert( treeView !is null );
		
		WrappedObject treeItem = null;
		if ( item !is null ) {
			treeItem = cast(WrappedObject)NativeBridge.forNative( item );
		}
		
		Object itemObject = (treeItem is null) ? null : treeItem.object;
		
		TreeViewDataSource dataSource = treeView.dataSource;
		if ( dataSource is null )
			return null;
		
		WrappedObject wrapped = new WrappedObject( dataSource.childAtIndex( treeView, itemObject, index ) );
		
		return wrapped.native;
	}
	
	native_handle _chisel_native_treeview_value_for_column_callback( native_handle treeview, native_handle item, native_handle column ) {
		TreeView treeView = cast(TreeView)NativeBridge.forNative( treeview );
		assert( treeView !is null );
		
		WrappedObject treeItem = null;
		if ( item !is null ) {
			treeItem = cast(WrappedObject)NativeBridge.forNative( item );
		}
		
		Object itemObject = (treeItem is null) ? null : treeItem.object;
		
		TableColumn tableColumn = cast(TableColumn)NativeBridge.forNative( column );
		assert( tableColumn !is null );
		
		TreeViewDataSource dataSource = treeView.dataSource;
		if ( dataSource is null )
			return null;
		
		return dataSource.valueForTableColumn( treeView, itemObject, tableColumn ).native;
	}
}

interface TreeViewDataSource {
	uint numberOfChildrenOfItem( TreeView treeView, Object item );
	bool isItemExpandable( TreeView treeView, Object item );
	Object childAtIndex( TreeView treeView, Object parent, uint index );
	CObject valueForTableColumn( TreeView treeView, Object item, TableColumn column );
}

class TreeView : View {
	TreeViewDataSource _dataSource;
	EventManager onSelectionChanged;
	
	this( ) {
		super( );
		native = _chisel_native_treeview_create( );
		_chisel_native_treeview_prepare( native );
		
		this.allowsColumnReordering = true;
		this.allowsColumnResizing = true;
		this.allowsMultipleSelection = false;
		this.allowsEmptySelection = true;
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
	
	void allowsMultipleSelection( bool val ) {
		_chisel_native_treeview_set_multiple_selection( native, val?1:0 );
	}
	
	bool allowsMultipleSelection( ) {
		return _chisel_native_treeview_get_multiple_selection( native ) != 0;
	}
	
	void allowsEmptySelection( bool val ) {
		_chisel_native_treeview_set_empty_selection( native, val?1:0 );
	}
	
	bool allowsEmptySelection( ) {
		return _chisel_native_treeview_get_empty_selection( native ) != 0;
	}
	
	TreeViewDataSource dataSource( ) {
		return _dataSource;
	}
	
	void dataSource( TreeViewDataSource dataSource ) {
		_dataSource = dataSource;
		reloadData( );
	}
	
	void reloadData( ) {
		_chisel_native_treeview_reload( native );
	}
	
	void outlineTableColumn( TableColumn column ) {
		_chisel_native_treeview_set_outline_column( native, column.native );
	}
	
	TableColumn outlineTableColumn( ) {
		native_handle column = _chisel_native_treeview_get_outline_column( native );
		
		return NativeBridge.fromNative!(TableColumn)( column );
	}
	
	void selectionChanged( ) {
		onSelectionChanged.call( this );
	}
	
	Object[] selectedRows( ) {
		Object[] rows;
		
		native_handle nrows = _chisel_native_treeview_get_selected_rows( native );
		CArray wrappedRowsN = NativeBridge.fromNative!(CArray)( nrows );
		WrappedObject[] wrappedRows = wrappedRowsN.toDArray!(WrappedObject)( );
		
		foreach ( row; wrappedRows ) {
			rows ~= row.object;
		}
		
		return rows;
	}
}
