module chisel.ui.openglview;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;
import chisel.ui.openglcontext;

extern (C) {
	native_handle _chisel_native_openglview_create( );
	native_handle _chisel_native_openglview_opengl_context( native_handle );
	
	void _chisel_native_openglview_prepare_opengl_callback( native_handle native ) {
		OpenGLView view = NativeBridge.fromNative!(OpenGLView)( native );
		assert( view !is null );
		
		view.prepareOpenGL( );
	}
	
	void _chisel_native_openglview_reshape_callback( native_handle native ) {
		OpenGLView view = NativeBridge.fromNative!(OpenGLView)( native );
		assert( view !is null );
		
		view.reshape( );
	}
	
	void _chisel_native_openglview_update_callback( native_handle native ) {
		OpenGLView view = NativeBridge.fromNative!(OpenGLView)( native );
		assert( view !is null );
		
		view.update( );
	}
}

class OpenGLView : View {
	this( ) {
		super( );
		native = _chisel_native_openglview_create( );
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	this( CLRect frame ) {
		this( );
		this.frame = frame;
	}
	
	OpenGLContext openGLContext( ) {
		native_handle context = _chisel_native_openglview_opengl_context( native );
		
		return NativeBridge.fromNative!(OpenGLContext)(context);
	}
	
	void prepareOpenGL( ) {
		
	}
	
	void reshape( ) {
		
	}
	
	void update( ) {
		this.openGLContext.update( );
	}
}