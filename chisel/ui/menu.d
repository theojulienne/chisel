module chisel.ui.menu;

import chisel.core.native;
import chisel.core.cobject;
import chisel.ui.menuitem;

extern (C) {
	native_handle _chisel_native_menu_create( );
	
	void _chisel_native_menu_insert_item( native_handle menu, uint index, native_handle item );
	uint _chisel_native_menu_item_count( native_handle menu );
	native_handle _chisel_native_menu_item_get( native_handle menu, uint index );
}

class Menu : CObject {
	this( ) {
		this( _chisel_native_menu_create( ) );
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	void insertItem( uint index, MenuItem item ) {
		_chisel_native_menu_insert_item( native, index, item.native );
	}
	
	void appendItem( MenuItem item ) {
		insertItem( itemCount, item );
	}
	
	void prependItem( MenuItem item ) {
		insertItem( 0, item );
	}
	
	MenuItem getItem( uint index ) {
		assert( index < itemCount );
		native_handle native = _chisel_native_menu_item_get( native, index );
		return NativeBridge.fromNative!(MenuItem)( native );
	}
	
	uint itemCount( ) {
		return _chisel_native_menu_item_count( native );
	}
}
