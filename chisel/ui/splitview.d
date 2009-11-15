module chisel.ui.splitview;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_splitview_create( int direction );
	
	void _chisel_native_splitview_set_divider_position( native_handle, int index, CLFloat position );
}

enum SplitterStacking {
	Horizontal=0,
	Vertical=1,
}

class SplitView : View {
	this( SplitterStacking direction ) {
		super( );
		native = _chisel_native_splitview_create( direction );
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	this( SplitterStacking direction, Rect frame ) {
		this( direction );
		this.frame = frame;
	}
	
	void setDividerPosition( int divider, CLFloat position ) {
		_chisel_native_splitview_set_divider_position( native, divider, position );
	}
}
