module chisel.ui.view;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;

extern (C) {
	native_handle _chisel_native_view_create( );
	void _chisel_native_view_set_frame( native_handle native, CLRect frame );
	CLRect _chisel_native_view_get_frame( native_handle native );
	void _chisel_native_view_add_subview( native_handle native, native_handle subview );
	void _chisel_native_view_invalidate_rect( native_handle native, CLRect frame );
	
	void _chisel_native_view_draw_rect_callback( native_handle native, CLRect rect ) {
		View view = NativeBridge.fromNative!(View)( native );
		assert( view !is null );
		
		view.drawRect( GraphicsContext.currentContext, rect );
	}
}

class View : CObject {
	this( native_handle hdl ) {
		super( parent );
		native = hdl;
	}
	
	this( ) {
		this( _chisel_native_view_create( ) );
	}
	
	void frame( CLRect frame ) {
		_chisel_native_view_set_frame( native, frame );
	}
	
	CLRect frame( ) {
		return _chisel_native_view_get_frame( native );
	}
	
	void drawRect( GraphicsContext context, CLRect rect ) {
		
	}
	
	void addSubview( View view ) {
		_chisel_native_view_add_subview( native, view.native );
	}
	
	void invalidate( ) {
		invalidate( frame );
	}
	
	void invalidate( CLRect dirty ) {
		_chisel_native_view_invalidate_rect( native, dirty );
	}
}