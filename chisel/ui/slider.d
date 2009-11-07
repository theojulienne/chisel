module chisel.ui.slider;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_slider_create( );
	
	void _chisel_native_slider_changed_callback( native_handle native ) {
		Slider slider = cast(Slider)NativeBridge.forNative( native );
		assert( slider !is null );
		
		slider.valueChanged( );
	}
}

class Slider : View {
	EventManager onChange;
	
	this( ) {
		super( );
		native = _chisel_native_slider_create( );
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	this( Rect frame ) {
		this( );
		this.frame = frame;
	}
	
	void valueChanged( ) {
		onChange.call( );
	}
}
