namespace Chisel.Core {
	
using System;
using System.Text;
using System.Runtime.InteropServices;

public class CString : CObject {
	[DllImport("chisel-core-native", CallingConvention=CallingConvention.Cdecl)]
	private static extern IntPtr _chisel_core_native_string_create_with_utf8_bytes( byte[] bytes, int len );
	
	[DllImport("chisel-core-native",
		EntryPoint="_chisel_core_native_string_utf8_bytes",
		CallingConvention=CallingConvention.Cdecl)]
	private static extern int _native_numBytes( IntPtr native );
	
	[DllImport("chisel-core-native",
		EntryPoint="_chisel_core_native_string_get_utf8",
		CallingConvention=CallingConvention.Cdecl)]
	private static extern void _native_toBuilder( IntPtr native, StringBuilder builder, int maxBytes );
	
	private static UTF8Encoding utf8 = new UTF8Encoding();
	
	public CString( String cliString ) {
		byte[] encodedBytes = utf8.GetBytes( cliString );
		
		nativeHandle = _chisel_core_native_string_create_with_utf8_bytes( encodedBytes, encodedBytes.Length );
	}
	
	public CString( ) {
		
	}
	
	public int byteLength {
		get {
			return _native_numBytes( nativeHandle );
		}
	}
	
	public String cliString {
		get {
			StringBuilder builder = new StringBuilder( byteLength + 1 );
			_native_toBuilder( nativeHandle, builder, builder.Capacity );
			
			return builder.ToString( );
		}
	}
}

}
