module chisel.graphics.context;

import chisel.core.all;
import chisel.graphics.all;
import chisel.graphics.types;
import chisel.graphics.path;

extern (C) {
	void _chisel_native_graphicscontext_save_graphics_state( native_handle );
	void _chisel_native_graphicscontext_restore_graphics_state( native_handle );
	//void _chisel_native_graphicscontext_set_current_context( native_handle );
	native_handle _chisel_native_graphicscontext_get_current_context( );
	
	void _chisel_native_graphicscontext_begin_path( native_handle );
	void _chisel_native_graphicscontext_move_to_point( native_handle, CLFloat x, CLFloat y );
	void _chisel_native_graphicscontext_line_to_point( native_handle, CLFloat x, CLFloat y );
	void _chisel_native_graphicscontext_curve_to_point( native_handle, CLFloat cp1X, CLFloat cp1Y, CLFloat cp2X, CLFloat cp2Y, CLFloat endX, CLFloat endY );
	void _chisel_native_graphicscontext_close_path( native_handle );
	
	void _chisel_native_graphicscontext_stroke_path( native_handle );
	void _chisel_native_graphicscontext_fill_path( native_handle );
	
	void _chisel_native_graphicscontext_translate( native_handle, CLFloat x, CLFloat y );
	void _chisel_native_graphicscontext_scale( native_handle, CLFloat x, CLFloat y );
	
	void _chisel_native_graphicscontext_set_fill_color( native_handle, CLFloat r, CLFloat g, CLFloat b, CLFloat a );
	void _chisel_native_graphicscontext_set_stroke_color( native_handle, CLFloat r, CLFloat g, CLFloat b, CLFloat a );
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
		super( );
		
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
	
	private void beginPath( ) {
		_chisel_native_graphicscontext_begin_path( native );
	}
	
	private void moveTo( CLFloat x, CLFloat y ) {
		_chisel_native_graphicscontext_move_to_point( native, x, y );
	}
	
	private void lineTo( CLFloat x, CLFloat y ) {
		_chisel_native_graphicscontext_line_to_point( native, x, y );
	}
	
	private void curveTo( CLFloat cp1X, CLFloat cp1Y, CLFloat cp2X, CLFloat cp2Y, CLFloat endX, CLFloat endY ) {
		_chisel_native_graphicscontext_curve_to_point( native, cp1X, cp1Y, cp2X, cp2Y, endX, endY );
	}
	
	private void closePath( ) {
		_chisel_native_graphicscontext_close_path( native );
	}
	
	private void strokePath( ) {
		_chisel_native_graphicscontext_stroke_path( native );
	}
	
	private void fillPath( ) {
		_chisel_native_graphicscontext_fill_path( native );
	}
	
	private void applyPath( Path path ) {
		beginPath( );
		
		foreach ( subpath; path.subpaths ) {
			foreach ( segment; subpath.segments ) {
				auto v = segment.items;
				switch ( segment.command ) {
					case PathCommand.MoveTo:
						moveTo( v[0], v[1] );
						break;
					case PathCommand.LineTo:
						lineTo( v[0], v[1] );
						break;
					case PathCommand.CurveTo:
						curveTo( v[0], v[1], v[2], v[3], v[4], v[5] );
						break;
					case PathCommand.Close:
						closePath( );
						break;
					default:
						assert( false );
				}
			}
		}
	}
	
	void stroke( Path path ) {
		applyPath( path );
		strokePath( );
	}
	
	void fill( Path path ) {
		applyPath( path );
		fillPath( );
	}
	
	void fillStroke( Path path ) {
		fill( path );
		stroke( path );
	}
	
	void translate( CLFloat x, CLFloat y ) {
		_chisel_native_graphicscontext_translate( native, x, y );
	}
	
	void scale( CLFloat x, CLFloat y ) {
		_chisel_native_graphicscontext_scale( native, x, y );
	}
	
	void fillColor( CLFloat r, CLFloat g, CLFloat b, CLFloat a ) {
		_chisel_native_graphicscontext_set_fill_color( native, r, g, b, a );
	}
	
	void fillColor( Color col ) {
		fillColor( col.red, col.green, col.blue, col.alpha );
	}
	
	void strokeColor( CLFloat r, CLFloat g, CLFloat b, CLFloat a ) {
		_chisel_native_graphicscontext_set_stroke_color( native, r, g, b, a );
	}
	
	void strokeColor( Color col ) {
		strokeColor( col.red, col.green, col.blue, col.alpha );
	}
}
