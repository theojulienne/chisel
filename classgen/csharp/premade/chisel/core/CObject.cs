namespace Chisel.Core {

using System;
using System.Reflection;
using System.Collections.Generic;

public class CObject {
	private IntPtr _native_handle = (IntPtr)0;
	
	public IntPtr nativeHandle {
		get { return _native_handle; }
		set {
			_native_handle = value;
			nativeMapping[value] = this;
		}
	}
	
	public CObject( ) {
	}
	
	private static Dictionary<IntPtr,CObject> nativeMapping = new Dictionary<IntPtr,CObject>( );
	public static CObject fromNative( Type type, IntPtr native ) {
		if ( !nativeMapping.ContainsKey( native ) ) {
			ConstructorInfo constructor = type.GetConstructor( Type.EmptyTypes );
			CObject inst = (CObject)constructor.Invoke( new Object[] {} );
			inst.nativeHandle = native;
			
			System.Console.WriteLine( "mapping to native object..." );
		}
		return nativeMapping[native];
	}
}

}
