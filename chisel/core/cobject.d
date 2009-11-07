module chisel.core.cobject;

import chisel.core.native;

class CObject {
	private native_handle _native;
	CObject parent;
	CObject children[];
	
	this( CObject parent ) {
		this.parent = parent;
		
		if ( parent !is null ) {
			parent.children ~= this;
		}
	}
	
	this( ) {
		this( null );
	}
	
	~this( ) {
		NativeBridge.destroy( this );
	}
	
	native_handle native( ) {
		return _native;
	}
	
	void native( native_handle n ) {
		_native = n;
		
		if ( n !is null ) {
			NativeBridge.register( this );
		}
	}
}
