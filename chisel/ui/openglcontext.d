module chisel.ui.openglcontext;

import chisel.core.all;
import chisel.graphics.all;
import chisel.graphics.path;

extern (C) {
	void _chisel_native_openglcontext_update( native_handle );
	void _chisel_native_openglcontext_make_current_context( native_handle );
	
	// static
	void _chisel_native_openglcontext_clear_current_context( );
	native_handle _chisel_native_openglcontext_get_current_context( );
}

class OpenGLContext : CObject {
	static void clearCurrentContext( ) {
		_chisel_native_openglcontext_clear_current_context( );
	}
	
	static OpenGLContext currentContext( ) {
		native_handle native = _chisel_native_openglcontext_get_current_context( );
		
		return NativeBridge.fromNative!(OpenGLContext)(native);
	}
	
	this( native_handle nativeContext ) {
		super( );
		
		native = nativeContext;
	}
	
	void makeCurrentContext( ) {
		_chisel_native_openglcontext_make_current_context( native );
	}
	
	void update( ) {
		_chisel_native_openglcontext_update( native );
	}
}
