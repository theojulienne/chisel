module chisel.ui.progressbar;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_progressbar_create( int direction );
	
	void _chisel_native_progressbar_set_minimum( native_handle, CLFloat );
	void _chisel_native_progressbar_set_maximum( native_handle, CLFloat );
	
	CLFloat _chisel_native_progressbar_get_thickness( native_handle );
	
	void _chisel_native_progressbar_set_value( native_handle, CLFloat );
	CLFloat _chisel_native_progressbar_get_value( native_handle );
	
	void _chisel_native_progressbar_set_indeterminate( native_handle, int );
	int _chisel_native_progressbar_get_indeterminate( native_handle );
	
	void _chisel_native_progressbar_set_animating( native_handle, int );
	int _chisel_native_progressbar_get_animating( native_handle );
}

enum ProgressBarType {
	Horizontal=0,
	Vertical=1,
}

class ProgressBar : View {
	ProgressBarType type;
	
	this( ProgressBarType type ) {
		super( );
		this.type = type;
		native = _chisel_native_progressbar_create( type );
		_chisel_native_progressbar_set_minimum( native, 0 );
		_chisel_native_progressbar_set_maximum( native, 1 );
	}
	
	this( native_handle native ) {
		super( native );
		assert( false ); // FIXME: determine type from native
	}
	
	this( ProgressBarType type, Rect frame ) {
		this( type );
		this.frame = frame;
	}
	
	void minValue( double val ) {
		_chisel_native_progressbar_set_minimum( native, val );
	}
	
	void maxValue( double val ) {
		_chisel_native_progressbar_set_maximum( native, val );
	}
	
	double value( ) {
		return _chisel_native_progressbar_get_value( native );
	}
	
	void value( double val ) {
		_chisel_native_progressbar_set_value( native, val );
	}
	
	bool indeterminate( ) {
		return _chisel_native_progressbar_get_indeterminate( native ) != 0;
	}
	
	void indeterminate( bool val ) {
		_chisel_native_progressbar_set_indeterminate( native, val ? 1 : 0 );
	}
	
	bool animating( ) {
		return _chisel_native_progressbar_get_animating( native ) != 0;
	}
	
	void animating( bool val ) {
		_chisel_native_progressbar_set_animating( native, val ? 1 : 0 );
	}
	
	SizeHint sizeHint( ) {
		SizeHint hint = super.sizeHint( );
		
		CLFloat thickness = _chisel_native_progressbar_get_thickness( native );
		
		if ( type == ProgressBarType.Horizontal ) {
			hint.suggestedSize.height = thickness;
		} else {
			hint.suggestedSize.width = thickness;
		}
		
		return hint;
	}
}
