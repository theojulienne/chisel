module chisel.core.exceptions;

import chisel.core.utf;

extern (C) {
	void _chisel_native_exception_bridge_init( );
	
	void _chisel_native_exception_raised( char *msg ) {
		throw new ChiselNativeException( fromStringz( msg ).dup );
	}
}

static this( ) {
	_chisel_native_exception_bridge_init( );
}

class ChiselNativeException : Exception {
	this( char[] msg ) {
		super( msg );
	}
}
