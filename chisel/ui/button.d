module chisel.ui.button;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_button_create( );
	
	void _chisel_native_button_set_enabled( native_handle, int );
	int _chisel_native_button_get_enabled( native_handle );
	
	CLFloat _chisel_native_button_get_height( native_handle );
	
	void _chisel_native_button_set_text( native_handle, native_handle );
	
	void _chisel_native_button_pressed_callback( native_handle native ) {
		Button button = cast(Button)NativeBridge.forNative( native );
		assert( button !is null );
		
		button.pressed( );
	}
}

class Button : View {
	EventManager onPress;
	
	this( ) {
		super( );
		native = _chisel_native_button_create( );
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
		return _chisel_native_button_get_enabled( native ) != 0;
	}
	
	void enabled( bool val ) {
		_chisel_native_button_set_enabled( native, val ? 1 : 0 );
	}
	
	void text( String buttonText ) {
		_chisel_native_button_set_text( native, buttonText.native );
	}
	
	void text( unicode buttonText ) {
		this.text = String.fromUTF8( buttonText );
	}
	
	void pressed( ) {
		onPress.call( this );
	}
	
	SizeHint sizeHint( ) {
		SizeHint hint = super.sizeHint( );
		
		CLFloat thickness = _chisel_native_button_get_height( native );
		
		hint.suggestedSize.height = thickness;
		
		return hint;
	}
}
