module chisel.core.native;

import chisel.core.cobject;

typedef void* native_handle;
typedef void* object_handle;

extern (C) {
	void _chisel_native_handle_destroy( native_handle native );
	
	void _chisel_native_handle_destroyed( native_handle native ) {
		if ( NativeBridge.isRegistered( native ) ) {
			CObject obj = NativeBridge.forNative( native );
			NativeBridge.deregister( obj );
			
			obj.native = null; // more?
		}
	}
	
	void _chisel_native_handle_bridge_registered( native_handle native );
	void _chisel_native_handle_bridge_deregistered( native_handle native );
	
	void _chisel_native_handle_current_references( native_handle native, int references ) {
		NativeBridge.setCurrentReferences( native, references );
	}
}

//import tango.stdc.stdio;
//import tango.io.Stdout;

class MaskedPointer {
	int _ptr;
	
	static const int magicXor = 0xffffffff;
	
	this( Object obj ) {
		mask( obj );
	}
	
	void mask( Object obj ) {
		_ptr = (cast(int)cast(void*)obj ^ magicXor);
	}
	
	Object unmask( ) {
		Object obj = cast(Object)(cast(void*)(_ptr ^ magicXor));
		return obj;
	}
	
	alias unmask unmasked;
	
	T get( T )( ) {
		return cast(T)unmask( );
	}
	
	hash_t toHash() {
		return unmasked.toHash( );
	}
	
	int opEquals(Object o) {
		return unmasked.opEquals(o);
	}
	
	int opCmp(Object o) {
		try {
			return unmasked.opCmp(o);
		} catch {
			return unmasked.opEquals(o) == 0;
		}
	}
}

static class NativeBridge {
	static MaskedPointer[native_handle] nativeToD;
	static native_handle[MaskedPointer] DToNative;
	
	static CObject[CObject] gcRetain;
	
	static this( ) {
		
	}
	
	static void setCurrentReferences( native_handle native, int references ) {
		if ( !NativeBridge.isRegistered( native ) )
			return;
		
		CObject obj = NativeBridge.forNative( native );
		assert( obj !is null );
		
		if ( references <= 1 ) {
			// if we have 1 or less native references, then the retaining
			// of the object is all up to the D GC, so make sure we have
			// no reference of our own
			
			if ( obj in gcRetain ) {
				gcRetain.remove( obj );
			}
		} else {
			// if we have more than 1 native reference, then a native object
			// is holding a reference. this means we need to hold a D reference
			// so the object doesn't get GCed
			
			if ( !(obj in gcRetain) ) {
				gcRetain[obj] = obj;
			}
		}
	}
	
	static void register( CObject obj ) {
		auto masked = new MaskedPointer( obj );
		
		nativeToD[obj.native] = masked;
		DToNative[masked] = obj.native;
		
		_chisel_native_handle_bridge_registered( obj.native );
	}
	
	static void deregister( CObject obj ) {
		if ( obj.native is null )
			return; // can't do anything here
		
		auto masked = new MaskedPointer( obj );
		
		setCurrentReferences( obj.native, 0 );
		
		nativeToD.remove( obj.native );
		DToNative.remove( masked );
		
		_chisel_native_handle_bridge_deregistered( obj.native );
		
		//Stdout.formatln( "NativeBridge.deregister( {} )", obj );
		//printf( "%p: deregistered from nativebridge\n", obj.native );
	}
	
	static void destroy( CObject obj ) {
		//Stdout.formatln( "NativeBridge.destroy( {} )", obj );
		//printf( "calling native destruction code for %p...\n", obj.native );
		
		// deregister. we're out.
		if ( obj.native !is null && isRegistered( obj.native ) ) {
			//printf( "now deregistering %p...\n", obj.native );
			deregister( obj );
		}
		
		_chisel_native_handle_destroy( obj.native );
	}
	
	static bool isRegistered( native_handle native ) {
		return (native in nativeToD) !is null;
	}
	
	static CObject forNative( native_handle native ) {
		assert( native in nativeToD );
		return cast(CObject)nativeToD[native].unmasked;
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