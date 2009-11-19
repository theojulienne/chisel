module chisel.core.number;

import chisel.core.all;
import chisel.core.cobject;
import chisel.core.native;

extern (C) {
	native_handle _chisel_native_number_create_with_double( double val );
	native_handle _chisel_native_number_create_with_int( int val );
	
	double _chisel_native_number_get_double( native_handle native );
	int _chisel_native_number_get_int( native_handle native );
}

class Number : CObject {
	this( double val ) {
		this( _chisel_native_number_create_with_double( val ) );
	}
	
	this( int val ) {
		this( _chisel_native_number_create_with_int( val ) );
	}
	
	this( native_handle native ) {
		super( );
		
		this.native = native;
	}
	
	int intValue( ) {
		return _chisel_native_number_get_int( native );
	}
	
	double doubleValue( ) {
		return _chisel_native_number_get_double( native );
	}
}
