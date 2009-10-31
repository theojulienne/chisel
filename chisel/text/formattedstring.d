module chisel.text.formattedtext;

import chisel.core.all;
import chisel.graphics.types;
import chisel.text.all;

extern (C) {
	native_handle _chisel_native_formattedstring_create( native_handle text );
	void _chisel_native_formattedstring_set_font( native_handle fs, CLRange range, native_handle font );
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
		super( null );
		
		this.native = native;
	}
	
	void setFont( CLRange range, Font font ) {
		_chisel_native_formattedstring_set_font( native, range, font.native );
	}
}
