module chisel.core.wrapped;

import chisel.core.all;
import chisel.core.cobject;
import chisel.core.native;

extern (C) {
	native_handle _chisel_native_create_wrapped_object( object_handle handle );
}

class WrappedObject : CObject {
	Object _obj;
	
	static WrappedObject[Object] objects;
	static WrappedObject forObject( Object obj ) {
		if ( !(obj in objects) ) {
			objects[obj] = new WrappedObject( obj );
		}
		
		return objects[obj];
	}
	
	this( Object object ) {
		_obj = object;
		this( _chisel_native_create_wrapped_object( cast(object_handle)object ) );
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	Object object( ) {
		return _obj;
	}
}
