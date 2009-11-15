module chisel.ui.slider;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_slider_create( int type );
	
	void _chisel_native_slider_set_minimum( native_handle, CLFloat );
	void _chisel_native_slider_set_maximum( native_handle, CLFloat );
	
	CLFloat _chisel_native_slider_get_thickness( native_handle );
	
	void _chisel_native_slider_set_value( native_handle, CLFloat );
	CLFloat _chisel_native_slider_get_value( native_handle );
	
	void _chisel_native_slider_changed_callback( native_handle native ) {
		Slider slider = cast(Slider)NativeBridge.forNative( native );
		assert( slider !is null );
		
		slider.valueChanged( );
	}
}

enum SliderType {
	Horizontal=0,
	Vertical=1,
}

class Slider : View {
	EventManager onChange;
	SliderType type;
	
	this( SliderType type ) {
		super( );
		this.type = type;
		native = _chisel_native_slider_create( type );
	}
	
	this( native_handle native ) {
		super( native );
		assert( false ); // FIXME: determine type from native
	}
	
	this( SliderType type, Rect frame ) {
		this( type );
		this.frame = frame;
	}
	
	void valueChanged( ) {
		onChange.call( this );
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
	
	SizeHint sizeHint( ) {
		SizeHint hint = super.sizeHint( );
		
		CLFloat thickness = _chisel_native_slider_get_thickness( native );
		
		if ( type == SliderType.Horizontal ) {
			hint.suggestedSize.height = thickness;
		} else {
			hint.suggestedSize.width = thickness;
		}
		
		return hint;
	}
}
