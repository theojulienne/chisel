module chisel.ui.tabview;

import chisel.core.native;
import chisel.core.cobject;
import chisel.ui.tabviewitem;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_tabview_create( );
	
	void _chisel_native_tabview_insert_item( native_handle tabview, uint index, native_handle item );
	void _chisel_native_tabview_remove_item( native_handle tabview, native_handle item );
	uint _chisel_native_tabview_item_count( native_handle tabview );
	native_handle _chisel_native_tabview_item_get( native_handle tabview, uint index );
	
	void _chisel_native_tabview_select_item( native_handle tabview, native_handle item );
	native_handle _chisel_native_tabview_get_selected_item( native_handle tabview );
}

class TabView : View {
	this( ) {
		this( _chisel_native_tabview_create( ) );
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	void insertItem( uint index, TabViewItem item ) {
		_chisel_native_tabview_insert_item( native, index, item.native );
	}
	
	void appendItem( TabViewItem item ) {
		insertItem( itemCount, item );
	}
	
	void prependItem( TabViewItem item ) {
		insertItem( 0, item );
	}
	
	void removeItem( TabViewItem item ) {
		_chisel_native_tabview_remove_item( native, item.native );
	}
	
	TabViewItem getItem( uint index ) {
		assert( index < itemCount );
		native_handle native = _chisel_native_tabview_item_get( native, index );
		return NativeBridge.fromNative!(TabViewItem)( native );
	}
	
	uint itemCount( ) {
		return _chisel_native_tabview_item_count( native );
	}
	
	void selectedItem( uint index ) {
		selectedItem = getItem( index );
	}
	
	void selectedItem( TabViewItem item ) {
		_chisel_native_tabview_select_item( native, item.native );
	}
	
	TabViewItem selectedItem( ) {
		native_handle native = _chisel_native_tabview_get_selected_item( native );
		return NativeBridge.fromNative!(TabViewItem)( native );
	}
}
