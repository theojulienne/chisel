module chisel.core.native;

import chisel.core.cobject;

typedef void* native_handle;


/* GC note:
The native bridge functions assume that CObject ptrs wont move.
In D1.0, this was how it worked, but not technically guarenteed.

This reference does not count as a GC reference.

In D2.0, the CObjects will need to be core.memory BlkAttr.NO_MOVE,
and the references in NativeBridge will need to be BlkAttr.NO_SCAN.
*/

version (Tango) {
	import tango.core.Memory;
	
	void registerObjectGC( CObject obj ) {
		// we hold a reference to this object, but pretend
		// it isn't a pointer, so it cannot be moved.
		
		uint attr = GC.getAttr( cast(void*)obj );
		attr |= GC.BlkAttr.NO_MOVE;
		GC.setAttr( cast(void*)obj, attr );
	}
} else {
	static import std.gc;
	
	void registerObjectGC( CObject obj ) {
		// if we could, we would set this to never move
		// because we hold a reference to it but pretend
		// it isn't a pointer
	}
}

static class NativeBridge {
	static int[native_handle] nativeToD;
	static native_handle[int] DToNative;
	
	static this( ) {
		
	}
	
	static int RefMagicXor = 0xffffffff;
	
	static int toPtrRef( CObject obj ) {
		return (cast(int)obj) ^ RefMagicXor;
	}
	
	static CObject fromPtrRef( int robj ) {
		return cast(CObject)(robj ^ RefMagicXor);
	}
	
	static void register( CObject obj ) {
		int ptrRef = toPtrRef(obj);
		
		nativeToD[obj.native] = ptrRef;
		DToNative[ptrRef] = obj.native;
		registerObjectGC( obj );
	}
	
	static void deregister( CObject obj ) {
		int ptrRef = toPtrRef(obj);
		
		nativeToD.remove( obj.native );
		DToNative.remove( ptrRef );
	}
	
	static bool isRegistered( native_handle native ) {
		return (native in nativeToD) !is null;
	}
	
	static CObject forNative( native_handle native ) {
		return cast(CObject)fromPtrRef(nativeToD[native]);
	}
	
	static T fromNative( T )( native_handle native ) {
		if ( !NativeBridge.isRegistered( native ) ) {
			T t = new T( native );
			assert( NativeBridge.isRegistered( native ) );
		}
		
		return cast(T)NativeBridge.forNative(native);
	}
	
	/*
	 ** going do this with native pointers instead -theo
	
	static Object[] refToObj;
	static int[Object] objToRef;
	static int currRef = 0;
	
	static int getReference( Object o ) {
		if ( !( o in objToRef ) ) {
			objToRef[o] = currRef;
			
			if ( refToObj.length == 0 ) {
				refToObj.length = 16;
			}
			
			if ( currRef >= refToObj.length ) {
				refToObj.length = refToObj.length + 2;
			}
			
			refToObj[currRef] = o;
			currRef++;
		}
		
		return objToRef[o];
	}
	
	static Object getObject( int r ) {
		return refToObj[r];
	}
	
	static void clearReference( int r ) {
		Object o = refToObj[r];
		
		objToRef.remove( o );
		refToObj[r] = null;
	}
	*/
}