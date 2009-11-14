module chisel.text.font;

import chisel.core.all;
import chisel.graphics.types;
import chisel.text.all;

extern (C) {
	native_handle _chisel_native_font_create_with_name( native_handle name, CLFloat size );
	CLFloat _chisel_native_font_get_size( native_handle );
	native_handle _chisel_native_font_get_family_name( native_handle );
	native_handle _chisel_native_font_get_full_name( native_handle );
}

class Font : CObject {
	static Font createWithName( String name, CLFloat size ) {
		native_handle native = _chisel_native_font_create_with_name( name.native, size );
		
		return NativeBridge.fromNative!(Font)(native);
	}
	
	static Font createWithName( unicode name, CLFloat size ) {
		return Font.createWithName( String.fromUTF8(name), size );
	}
	
	this( native_handle native ) {
		super( );
		
		this.native = native;
	}
	
	CLFloat size( ) {
		return _chisel_native_font_get_size( native );
	}
	
	String familyName( ) {
		native_handle str = _chisel_native_font_get_family_name( native );
		
		return NativeBridge.fromNative!(String)(str);
	}
	
	String fullName( ) {
		native_handle str = _chisel_native_font_get_full_name( native );
		
		return NativeBridge.fromNative!(String)(str);
	}
}
