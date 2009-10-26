module chisel.graphics.context;

import chisel.core.all;
import chisel.graphics.all;
import chisel.graphics.path;

extern (C) {
	void _chisel_native_graphicscontext_save_graphics_state( native_handle );
	void _chisel_native_graphicscontext_restore_graphics_state( native_handle );
	void _chisel_native_graphicscontext_draw_text( native_handle, char* );
	//void _chisel_native_graphicscontext_set_current_context( native_handle );
	native_handle _chisel_native_graphicscontext_get_current_context( );
}

class GraphicsContext : CObject {
	/*static void setCurrentContext( GraphicsContext ctx ) {
		_chisel_native_graphicscontext_set_current_context( ctx.native );
	}*/
	
	static GraphicsContext currentContext( ) {
		native_handle native = _chisel_native_graphicscontext_get_current_context( );
		
		return NativeBridge.fromNative!(GraphicsContext)(native);
	}
	
	this( native_handle nativeContext ) {
		super( null );
		
		native = nativeContext;
	}
	
	void saveGraphicsState( ) {
		_chisel_native_graphicscontext_save_graphics_state( native );
	}
	
	void restoreGraphicsState( ) {
		_chisel_native_graphicscontext_restore_graphics_state( native );
	}
	
	void yIncreasesUp( bool val ) {
		
	}
	
	alias yIncreasesUp yUp;
	
	void stroke( Path path ) {
		
	}
	
	void fill( Path path ) {
		
	}
	
	void fillStroke( Path path ) {
		fill( path );
		stroke( path );
	}
	
	void drawText( unicode text ) {
		_chisel_native_graphicscontext_draw_text( native, toStringz(text) );
	}
}
