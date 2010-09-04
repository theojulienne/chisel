package chisel.core;

public class CObject {
	private long native_handle = 0;
	
	private long getNativeHandle( ) {
		return native_handle;
	}
	
	private void setNativeHandle( long handle ) {
		native_handle = handle;
	}
	
	public CObject( ) {
	}
}
