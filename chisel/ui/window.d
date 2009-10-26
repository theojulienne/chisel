module chisel.ui.window;

import chisel.core.all;
import chisel.ui.native;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_window_create( );
	void _chisel_native_window_set_title( native_handle, char* );
	void _chisel_native_window_set_visible( native_handle, int );
	void _chisel_native_window_set_content_size( native_handle, CLSize );
	native_handle _chisel_native_window_get_content_view( native_handle );
	void _chisel_native_window_set_content_view( native_handle, native_handle );
	void _chisel_native_window_close( native_handle );
	
	void _chisel_native_window_will_close_callback( native_handle native ) {
		Window window = cast(Window)NativeBridge.forNative( native );
		assert( window !is null );
		
		window.willClose( );
	}
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
	
	void title( unicode title ) {
		_chisel_native_window_set_title( native, toStringz(title) );
	}
	
	void visible( bool visibility ) {
		_chisel_native_window_set_visible( native, visibility?1:0 );
	}
	
	void show( ) {
		visible = true;
	}
	
	void size( CLSize size ) {
		_chisel_native_window_set_content_size( native, size );
	}
	
	void setSize( float width, float height ) {
		CLSize newSize;
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
		onClose.call( );
	}
	
	void performClose( ) {
		close( );
	}
}