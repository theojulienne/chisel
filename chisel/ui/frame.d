module chisel.ui.frame;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_frame_create( );
	
	void _chisel_native_frame_set_title( native_handle, native_handle );
	
	native_handle _chisel_native_frame_get_content_view( native_handle );
	void _chisel_native_frame_set_content_view( native_handle, native_handle );
}

class Frame : View {
	this( ) {
		super( );
		native = _chisel_native_frame_create( );
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	this( Rect frame ) {
		this( );
		this.frame = frame;
	}
	
	void title( String titleText ) {
		_chisel_native_frame_set_title( native, titleText.native );
	}
	
	void title( unicode titleText ) {
		this.title = String.fromUTF8( titleText );
	}
	
	View contentView( ) {
		native_handle native = _chisel_native_frame_get_content_view( native );
		return NativeBridge.fromNative!(View)( native );
	}
	
	void contentView( View view ) {
		assert( view !is null );
		
		_chisel_native_frame_set_content_view( native, view.native );
	}
	
	SizeHint sizeHint( ) {
		SizeHint hint = contentView.sizeHint( );
		
		Size frameSize = frame.size;
		Size contentSize = contentView.frame.size;
		
		double myExtraWidth = frameSize.width - contentSize.width;
		double myExtraHeight = frameSize.height - contentSize.height;
		
		if ( hint.suggestedSize.width != SizeHint.DontCare ) {
			hint.suggestedSize.width += myExtraWidth;
		}
		
		if ( hint.suggestedSize.height != SizeHint.DontCare ) {
			hint.suggestedSize.height += myExtraHeight;
		}
		
		return hint;
	}
}
