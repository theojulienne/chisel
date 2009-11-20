module chisel.ui.view;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.core.array;

extern (C) {
	native_handle _chisel_native_view_create( );
	void _chisel_native_view_set_frame( native_handle native, Rect frame );
	Rect _chisel_native_view_get_frame( native_handle native );
	void _chisel_native_view_add_subview( native_handle native, native_handle subview );
	native_handle _chisel_native_view_get_subviews( native_handle native );
	void _chisel_native_view_invalidate_rect( native_handle native, Rect frame );
	
	void _chisel_native_view_draw_rect_callback( native_handle native, Rect rect ) {
		View view = NativeBridge.fromNative!(View)( native );
		assert( view !is null );
		
		view.drawRect( GraphicsContext.currentContext, rect );
	}
	
	void _chisel_native_view_frame_changed_callback( native_handle native ) {
		View view = NativeBridge.fromNative!(View)( native );
		assert( view !is null );
		
		view.frameChanged( );
	}
}

struct SizeHint {
	static const CLFloat DontCare = -1.0;
	
	Size suggestedSize;
	
	static SizeHint opCall( CLFloat width, CLFloat height ) {
		SizeHint hint;
		
		hint.suggestedSize.width = width;
		hint.suggestedSize.height = height;
		
		return hint;
	}
	
	static SizeHint noHints( ) {
		return SizeHint( DontCare, DontCare );
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
	
	void frame( Rect frame ) {
		_chisel_native_view_set_frame( native, frame );
	}
	
	Rect frame( ) {
		return _chisel_native_view_get_frame( native );
	}
	
	void drawRect( GraphicsContext context, Rect rect ) {
		
	}
	
	void addSubview( View view ) {
		_chisel_native_view_add_subview( native, view.native );
	}
	
	void invalidate( ) {
		invalidate( frame );
	}
	
	void invalidate( Rect dirty ) {
		_chisel_native_view_invalidate_rect( native, dirty );
	}
	
	SizeHint sizeHint( ) {
	   SizeHint hint = SizeHint.noHints;

	   hint.suggestedSize = this.frame.size;

	   return hint;
	}
	
	View[] subviews( ) {
		native_handle arr = _chisel_native_view_get_subviews( native );
		
		CArray carr = NativeBridge.fromNative!(CArray)( arr );
		assert( carr !is null );
		
		return carr.toDArray!(View);
	}
	
	void frameChanged( ) {
		
	}
}