module chisel.ui.menuitem;

import chisel.core.native;
import chisel.core.events;
import chisel.core.string;
import chisel.core.utf;
import chisel.core.cobject;
import chisel.graphics.image;
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
	
	void _chisel_native_menuitem_set_key_equivalent( native_handle menuitem, native_handle key );
	native_handle _chisel_native_menuitem_get_key_equivalent( native_handle menuitem );
	
	void _chisel_native_menuitem_set_key_equivalent_modifiers( native_handle menuitem, int modifiers );
	int _chisel_native_menuitem_get_key_equivalent_modifiers( native_handle menuitem );
	
	void _chisel_native_menuitem_set_image( native_handle menuitem, native_handle image );
	native_handle _chisel_native_menuitem_get_image( native_handle menuitem );
}

enum ModifierKey {
	Shift=0x01,
	Alternate=0x02,
	Command=0x04,
	Control=0x08,
	
	NativeDefault=0x10,
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
	
	this( String title, String keyEquivalent ) {
		this( title );
		this.keyEquivalent = keyEquivalent;
	}
	
	this( unicode title, unicode keyEquivalent ) {
		this( title );
		this.keyEquivalent = keyEquivalent;
	}
	
	this( String title, String keyEquivalent, ModifierKey keyEquivalentModifiers ) {
		this( title, keyEquivalent );
		this.keyEquivalentModifiers = keyEquivalentModifiers;
	}
	
	this( unicode title, unicode keyEquivalent, ModifierKey keyEquivalentModifiers ) {
		this( title, keyEquivalent );
		this.keyEquivalentModifiers = keyEquivalentModifiers;
	}
	
	this( Image image, String title ) {
		this( title );
		this.image = image;
	}
	
	this( Image image, unicode title ) {
		this( title );
		this.image = image;
	}
	
	this( Image image, String title, String keyEquivalent ) {
		this( title, keyEquivalent );
		this.image = image;
	}
	
	this( Image image, unicode title, unicode keyEquivalent ) {
		this( title, keyEquivalent );
		this.image = image;
	}
	
	this( Image image, String title, String keyEquivalent, ModifierKey keyEquivalentModifiers ) {
		this( title, keyEquivalent, keyEquivalentModifiers );
		this.image = image;
	}
	
	this( Image image, unicode title, unicode keyEquivalent, ModifierKey keyEquivalentModifiers ) {
		this( title, keyEquivalent, keyEquivalentModifiers );
		this.image = image;
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
	
	void keyEquivalent( String key ) {
		_chisel_native_menuitem_set_key_equivalent( native, key.native );
	}
	
	void keyEquivalent( unicode key ) {
		this.keyEquivalent = String.fromUTF8( key );
	}
	
	String keyEquivalent( ) {
		native_handle nKey = _chisel_native_menuitem_get_key_equivalent( native );
		return NativeBridge.fromNative!(String)( nKey );
	}
	
	void keyEquivalentModifiers( ModifierKey mask ) {
		_chisel_native_menuitem_set_key_equivalent_modifiers( native, mask );
	}
	
	ModifierKey keyEquivalentModifiers( ) {
		return cast(ModifierKey)_chisel_native_menuitem_get_key_equivalent_modifiers( native );
	}
	
	void addModifier( ModifierKey key ) {
		this.keyEquivalentModifiers = this.keyEquivalentModifiers | key;
	}
	
	void image( Image image ) {
		_chisel_native_menuitem_set_image( native, image.native );
	}
	
	Image image( ) {
		native_handle nImage = _chisel_native_menuitem_get_image( native );
		return NativeBridge.fromNative!(Image)( nImage );
	}
}
