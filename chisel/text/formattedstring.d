module chisel.text.formattedstring;

import chisel.core.all;
import chisel.graphics.types;
import chisel.graphics.context;
import chisel.text.all;

extern (C) {
	native_handle _chisel_native_formattedstring_create( native_handle text );
	void _chisel_native_formattedstring_set_font( native_handle fs, Range range, native_handle font );
	native_handle _chisel_native_formattedstring_get_string( native_handle fs );
	void _chisel_native_formattedstring_draw( native_handle fs, native_handle ctx, Point point );
}

class FormattedString : CObject {
	static FormattedString createWithString( String text ) {
		native_handle native = _chisel_native_formattedstring_create( text.native );
		
		return NativeBridge.fromNative!(FormattedString)(native);
	}
	
	static FormattedString createWithString( unicode text ) {
		return FormattedString.createWithString( String.fromUTF8(text) );
	}
	
	this( native_handle native ) {
		super( );
		
		this.native = native;
	}
	
	void setFont( Range range, Font font ) {
		_chisel_native_formattedstring_set_font( native, range, font.native );
	}
	
	String string( ) {
		native_handle native = _chisel_native_formattedstring_get_string( native );
		
		return NativeBridge.fromNative!(String)(native);
	}
	
	Range range( ) {
		return Range( 0, string.length );
	}
	
	void drawToContext( GraphicsContext context, Point point ) {
		_chisel_native_formattedstring_draw( native, context.native, point );
	}
}
