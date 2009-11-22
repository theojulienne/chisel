module chisel.core.array;

import chisel.core.all;
import chisel.core.cobject;
import chisel.core.native;

extern (C) {
	native_handle _chisel_native_array_from_natives( native_handle *natives, int count );
	uint _chisel_native_array_get_length( native_handle );
	native_handle _chisel_native_array_get_object( native_handle, uint index );
}

class CArray : CObject {
	static CArray withObjects( CObject[] objects ) {
		native_handle[] natives;
		natives.length = objects.length;
		
		foreach ( i, object; objects ) {
			natives[i] = object.native;
		}
		
		native_handle native = _chisel_native_array_from_natives( natives.ptr, natives.length );
		
		return new CArray( native );
	}
	
	this( native_handle native ) {
		super( );
		
		this.native = native;
	}
	
	uint length( ) {
		return _chisel_native_array_get_length( native );
	}
	
	uint count( ) {
		return length;
	}
	
	T objectAtIndex( T )( uint index ) {
		native_handle n = _chisel_native_array_get_object( native, index );
		
		T obj = NativeBridge.fromNative!(T)(n);
		assert( obj !is null );
		
		return obj;
	}
	
	T[] toDArray( T )( ) {
		T[] darr;
		
		int els = length;
		darr.length = els;
		for ( int i = 0; i < els; i++ ) {
			darr[i] = objectAtIndex!(T)( i );
		}
		
		return darr;
	}
}
