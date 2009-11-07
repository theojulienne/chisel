module chisel.core.native;

import chisel.core.cobject;

typedef void* native_handle;

extern (C) {
	void _chisel_native_handle_destroy( native_handle native );
	
	void _chisel_native_handle_destroyed( native_handle native ) {
		if ( NativeBridge.isRegistered( native ) ) {
			CObject obj = NativeBridge.forNative( native );
			NativeBridge.deregister( obj );
			
			obj.native = null; // more?
		}
	}
}

//import tango.stdc.stdio;
//import tango.io.Stdout;

static class NativeBridge {
	static CObject[native_handle] nativeToD;
	static native_handle[CObject] DToNative;
	
	static this( ) {
		
	}
	
	static void register( CObject obj ) {
		nativeToD[obj.native] = obj;
		DToNative[obj] = obj.native;
	}
	
	static void deregister( CObject obj ) {
		if ( obj.native is null )
			return; // can't do anything here
		
		nativeToD.remove( obj.native );
		DToNative.remove( obj );
		
		//Stdout.formatln( "NativeBridge.deregister( {} )", obj );
		//printf( "%p: deregistered from nativebridge\n", obj.native );
	}
	
	static void destroy( CObject obj ) {
		//Stdout.formatln( "NativeBridge.destroy( {} )", obj );
		//printf( "calling native destruction code for %p...\n", obj.native );
		
		_chisel_native_handle_destroy( obj.native );
		
		// if still registered, deregister. we're out.
		if ( obj.native !is null && isRegistered( obj.native ) ) {
			//printf( "now deregistering %p...\n", obj.native );
			deregister( obj );
		}
	}
	
	static bool isRegistered( native_handle native ) {
		return (native in nativeToD) !is null;
	}
	
	static CObject forNative( native_handle native ) {
		return cast(CObject)nativeToD[native];
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