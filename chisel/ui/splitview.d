module chisel.ui.splitview;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_splitview_create( );
	
	void _chisel_native_splitview_set_vertical( native_handle, int );
	int _chisel_native_splitview_get_vertical( native_handle );
	
	void _chisel_native_splitview_set_divider_position( native_handle, int index, CLFloat position );
}

class SplitView : View {
	this( ) {
		super( );
		native = _chisel_native_splitview_create( );
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	this( Rect frame ) {
		this( );
		this.frame = frame;
	}
	
	bool vertical( ) {
		return _chisel_native_splitview_get_vertical( native ) != 0;
	}
	
	void vertical( bool val ) {
		_chisel_native_splitview_set_vertical( native, val ? 1 : 0 );
	}
	
	void setDividerPosition( int divider, CLFloat position ) {
		_chisel_native_splitview_set_divider_position( native, divider, position );
	}
}
