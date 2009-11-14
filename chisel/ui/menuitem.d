module chisel.ui.menuitem;

import chisel.core.native;
import chisel.core.events;
import chisel.core.string;
import chisel.core.utf;
import chisel.core.cobject;
import chisel.ui.menu;

extern (C) {
	native_handle _chisel_native_menuitem_create( );
	native_handle _chisel_native_menuitem_create_separator( );
	
	void _chisel_native_menuitem_set_submenu( native_handle menuitem, native_handle submenu );
	native_handle _chisel_native_menuitem_get_submenu( native_handle menuitem );
	
	void _chisel_native_menuitem_set_enabled( native_handle menuitem, int flag );
	int _chisel_native_menuitem_get_enabled( native_handle menuitem );
	
	void _chisel_native_menuitem_set_visible( native_handle menuitem, int flag );
	int _chisel_native_menuitem_get_visible( native_handle menuitem );
	
	void _chisel_native_menuitem_set_title( native_handle menuitem, native_handle title );
	native_handle _chisel_native_menuitem_get_title( native_handle menuitem );
	
	void _chisel_native_menuitem_pressed_callback( native_handle native ) {
		MenuItem menuItem = cast(MenuItem)NativeBridge.forNative( native );
		assert( menuItem !is null );
		
		menuItem.pressed( );
	}
}

class MenuItem : CObject {
	EventManager onPress;
	
	static MenuItem separatorItem( ) {
		return new MenuItem( _chisel_native_menuitem_create_separator( ) );
	}
	
	this( ) {
		this( _chisel_native_menuitem_create( ) );
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	this( String title ) {
		this( );
		this.title = title;
	}
	
	this( unicode title ) {
		this( );
		this.title = title;
	}
	
	void submenu( Menu submenu ) {
		_chisel_native_menuitem_set_submenu( native, submenu.native );
	}
	
	Menu submenu( ) {
		native_handle nSubmenu = _chisel_native_menuitem_get_submenu( native );
		return NativeBridge.fromNative!(Menu)( nSubmenu );
	}
	
	void enabled( bool val ) {
		_chisel_native_menuitem_set_enabled( native, val?1:0 );
	}
	
	bool enabled( ) {
		return _chisel_native_menuitem_get_enabled( native ) != 0;
	}
	
	void visible( bool val ) {
		_chisel_native_menuitem_set_visible( native, val?1:0 );
	}
	
	bool visible( ) {
		return _chisel_native_menuitem_get_visible( native ) != 0;
	}
	
	void title( String titleText ) {
		_chisel_native_menuitem_set_title( native, titleText.native );
	}
	
	void title( unicode titleText ) {
		this.title = String.fromUTF8( titleText );
	}
	
	String title( ) {
		native_handle nTitle = _chisel_native_menuitem_get_title( native );
		return NativeBridge.fromNative!(String)( nTitle );
	}
	
	void pressed( ) {
		onPress.call( this );
	}
}
