module chisel.core.string;

import chisel.core.all;
import chisel.core.cobject;
import chisel.core.native;

extern (C) {
	// note "bytes" does not include the terminating NULL character
	native_handle _chisel_native_string_create_with_utf8_bytes( char* buf, int bytes );
	
	// returns the number of unicode characters
	// (note this may not be the same as the byte length)
	int _chisel_native_string_unicode_length( native_handle );
	
	// returns the number of bytes required to represent this string in utf8
	// this does NOT include the NULL terminating character
	int _chisel_native_string_utf8_bytes( native_handle );
	
	// fills buf with a NULL terminated utf8 string, using no more than maxBytes
	// bytes.
	void _chisel_native_string_get_utf8( native_handle, char* buf, int maxBytes );
	
	// compares 2 native strings for equality
	int _chisel_native_string_equals( native_handle lhs, native_handle rhs );
	
	// compares 2 native strings, returning the D-style opCmp order
	// (lhs < rhs) --> lhs.opCmd(rhs) < 0
	int _chisel_native_string_compare( native_handle lhs, native_handle rhs );
}

class String : CObject {
	static String fromUTF8( unicode text ) {
		native_handle native = _chisel_native_string_create_with_utf8_bytes( text.ptr, text.length );
		
		return NativeBridge.fromNative!(String)(native);
	}
	
	alias fromUTF8 withUTF8;
	
	this( native_handle native ) {
		super( null );
		
		this.native = native;
	}
	
	int length( ) {
		return _chisel_native_string_unicode_length( native );
	}
	
	unicode dString( ) {
		unicode ustr;
		
		ustr.length = _chisel_native_string_utf8_bytes( native ) + 1;
		_chisel_native_string_get_utf8( native, ustr.ptr, ustr.length );
		
		// D doesn't want the null terminator, slice it out
		ustr = ustr[0..$-1];
		
		return ustr;
	}
	
	char* cString( ) {
		unicode ustr;
		
		ustr.length = _chisel_native_string_utf8_bytes( native ) + 1;
		_chisel_native_string_get_utf8( native, ustr.ptr, ustr.length );
		
		return ustr.ptr;
	}
	
	bool opEquals( String other ) {
		return _chisel_native_string_equals( this.native, other.native ) != 0;
	}
	
	bool opEquals( unicode other ) {
		String tmp = String.withUTF8( other );
		return opEquals( tmp );
	}
	
	int opCmp( String other ) {
		return _chisel_native_string_compare( this.native, other.native );
	}
	
	int opCmp( unicode other ) {
		String tmp = String.withUTF8( other );
		return opCmp( tmp );
	}
}

unittest {
	char[] snowman = "☃";
	
	printf( "Testing chisel.core.string...\n" );
	
	String s = String.withUTF8( snowman );
	
	// unicode snowman is 1 unicode character, but takes 3 bytes
	assert( s.length == 1 && snowman.length == 3 );
	
	// check for equality between utf8 and String
	assert( s == snowman );
	
	// check for inequality between utf8 and String
	assert( s != "oh hai" );
}
