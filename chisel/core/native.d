module chisel.core.native;

import chisel.core.cobject;

typedef void* native_handle;

static class NativeBridge {
	static CObject[native_handle] nativeToD;
	static native_handle[CObject] DToNative;
	
	static void register( CObject obj ) {
		nativeToD[obj.native] = obj;
		DToNative[obj] = obj.native;
	}
	
	static bool isRegistered( native_handle native ) {
		return (native in nativeToD) !is null;
	}
	
	static CObject forNative( native_handle native ) {
		return nativeToD[native];
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