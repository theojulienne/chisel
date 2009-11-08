module chisel.ui.label;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_label_create( );
	
	void _chisel_native_label_set_selectable( native_handle, int );
	int _chisel_native_label_get_selectable( native_handle );
	
	CLFloat _chisel_native_label_get_height( native_handle );
	
	void _chisel_native_label_set_text( native_handle, native_handle );
}

class Label : View {
	this( ) {
		super( );
		native = _chisel_native_label_create( );
	}
	
	this( unicode text ) {
		this( );
		this.text = text;
	}
	
	this( String text ) {
		this( );
		this.text = text;
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	this( Rect frame ) {
		this( );
		this.frame = frame;
	}
	
	bool selectable( ) {
		return _chisel_native_label_get_selectable( native ) != 0;
	}
	
	void selectable( bool val ) {
		_chisel_native_label_set_selectable( native, val ? 1 : 0 );
	}
	
	void text( String labelText ) {
		_chisel_native_label_set_text( native, labelText.native );
	}
	
	void text( unicode labelText ) {
		this.text = String.fromUTF8( labelText );
	}
	
	SizeHint sizeHint( ) {
		SizeHint hint = super.sizeHint( );
		
		CLFloat thickness = _chisel_native_label_get_height( native );
		
		hint.suggestedSize.height = thickness;
		
		return hint;
	}
}
