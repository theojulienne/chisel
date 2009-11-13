module chisel.ui.checkbox;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_checkbox_create( );
	
	void _chisel_native_checkbox_set_enabled( native_handle, int );
	int _chisel_native_checkbox_get_enabled( native_handle );
	
	void _chisel_native_checkbox_set_checked( native_handle, int );
	int _chisel_native_checkbox_get_checked( native_handle );
	
	CLFloat _chisel_native_checkbox_get_height( native_handle );
	
	void _chisel_native_checkbox_set_text( native_handle, native_handle );
	
	void _chisel_native_checkbox_changed_callback( native_handle native ) {
		CheckBox checkbox = cast(CheckBox)NativeBridge.forNative( native );
		assert( checkbox !is null );
		
		checkbox.changed( );
	}
}

class CheckBox : View {
	EventManager onChange;
	
	this( ) {
		super( );
		native = _chisel_native_checkbox_create( );
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
	
	bool enabled( ) {
		return _chisel_native_checkbox_get_enabled( native ) != 0;
	}
	
	void enabled( bool val ) {
		_chisel_native_checkbox_set_enabled( native, val ? 1 : 0 );
	}
	
	bool checked( ) {
		return _chisel_native_checkbox_get_checked( native ) != 0;
	}
	
	void checked( bool val ) {
		_chisel_native_checkbox_set_checked( native, val ? 1 : 0 );
	}
	
	void text( String checkboxText ) {
		_chisel_native_checkbox_set_text( native, checkboxText.native );
	}
	
	void text( unicode checkboxText ) {
		this.text = String.fromUTF8( checkboxText );
	}
	
	void changed( ) {
		onChange.call( this );
	}
	
	SizeHint sizeHint( ) {
		SizeHint hint = super.sizeHint( );
		
		CLFloat thickness = _chisel_native_checkbox_get_height( native );
		
		hint.suggestedSize.height = thickness;
		
		return hint;
	}
}
