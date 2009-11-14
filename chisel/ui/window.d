module chisel.ui.window;

import chisel.core.all;
import chisel.ui.native;
import chisel.ui.view;
import chisel.ui.menubar;

extern (C) {
	native_handle _chisel_native_window_create( );
	
	void _chisel_native_window_set_title( native_handle, native_handle str );
	
	void _chisel_native_window_set_visible( native_handle, int );
	
	void _chisel_native_window_set_content_size( native_handle, Size );
	
	native_handle _chisel_native_window_get_content_view( native_handle );
	void _chisel_native_window_set_content_view( native_handle, native_handle );
	
	void _chisel_native_window_close( native_handle );
	void _chisel_native_window_will_close_callback( native_handle native ) {
		Window window = cast(Window)NativeBridge.forNative( native );
		assert( window !is null );
		
		window.willClose( );
	}
	
	void _chisel_native_window_set_menubar( native_handle window, native_handle menubar );
	native_handle _chisel_native_window_get_menubar( native_handle window );
	
}

class Window : CObject {
	this( ) {
		super( );
		native = _chisel_native_window_create( );
	}
	
	this( unicode title ) {
		this( );
		this.title = title;
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	void title( String title ) {
		_chisel_native_window_set_title( native, title.native );
	}
	
	void title( unicode title ) {
		this.title = String.fromUTF8(title);
	}
	
	void visible( bool visibility ) {
		_chisel_native_window_set_visible( native, visibility?1:0 );
	}
	
	void show( ) {
		visible = true;
	}
	
	void size( Size size ) {
		_chisel_native_window_set_content_size( native, size );
	}
	
	void setSize( float width, float height ) {
		Size newSize;
		newSize.width = width;
		newSize.height = height;
		size( newSize );
	}
	
	View contentView( ) {
		native_handle native = _chisel_native_window_get_content_view( native );
		return NativeBridge.fromNative!(View)( native );
	}
	
	void contentView( View view ) {
		assert( view !is null );
		
		_chisel_native_window_set_content_view( native, view.native );
	}
	
	EventManager onClose;
	
	void close( ) {
		_chisel_native_window_close( native );
	}
	
	void willClose( ) {
		onClose.call( this );
	}
	
	void performClose( ) {
		close( );
	}
	
	void menubar( MenuBar menubar ) {
		_chisel_native_window_set_menubar( native, menubar.native );
	}
	
	MenuBar menubar( ) {
		native_handle nMenubar = _chisel_native_window_get_menubar( native );
		return NativeBridge.fromNative!(MenuBar)( nMenubar );
	}
}