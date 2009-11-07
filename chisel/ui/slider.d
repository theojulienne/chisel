module chisel.ui.slider;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_slider_create( );
	
	void _chisel_native_slider_set_minimum( native_handle, CLFloat );
	void _chisel_native_slider_set_maximum( native_handle, CLFloat );
	
	void _chisel_native_slider_set_value( native_handle, CLFloat );
	CLFloat _chisel_native_slider_get_value( native_handle );
	
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
	
	void minValue( double val ) {
		_chisel_native_slider_set_minimum( native, val );
	}
	
	void maxValue( double val ) {
		_chisel_native_slider_set_maximum( native, val );
	}
	
	double value( ) {
		return _chisel_native_slider_get_value( native );
	}
	
	void value( double val ) {
		_chisel_native_slider_set_value( native, val );
	}
}
