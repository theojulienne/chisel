module chisel.graphics.path;

import chisel.core.all;
import chisel.graphics.all;

import chisel.graphics.types;

class Path {
	SubPath[] subpaths;
	
	this( ) {
		subpaths ~= new SubPath;
	}
	
	class SubPath {
		bool isEmpty( ) {
			assert( false );
			return true;
		}
		
		void moveTo( CLFloat x, CLFloat y ) {
			
		}
		
		void lineTo( CLFloat x, CLFloat y ) {
			
		}
		
		void curveTo( CLFloat cp1X, CLFloat cp1Y, CLFloat cp2X, CLFloat cp2Y, CLFloat endX, CLFloat endY ) {
			
		}
		
		void close( ) {
			
		}
	}
	
	bool isEmpty( ) {
		// return not empty if any subpath is not empty
		foreach ( subpath; subpaths ) {
			if ( !subpath.isEmpty( ) ) {
				return false;
			}
		}
		
		return true;
	}
	
	// wrappers that call subpaths
	void moveTo( CLFloat x, CLFloat y ) {
		subpaths[$-1].moveTo( x, y );
	}
	
	void moveTo( CLPoint point ) {
		moveTo( point.x, point.y );
	}
	
	void lineTo( CLFloat x, CLFloat y ) {
		subpaths[$-1].lineTo( x, y );
	}
	
	void lineTo( CLPoint point ) {
		lineTo( point.x, point.y );
	}
	
	void curveTo( CLFloat cp1X, CLFloat cp1Y, CLFloat cp2X, CLFloat cp2Y, CLFloat endX, CLFloat endY ) {
		subpaths[$-1].curveTo( cp1X, cp1Y, cp2X, cp2Y, endX, endY );
	}
	
	void curveTo( CLPoint cpStart, CLPoint cpEnd, CLPoint end ) {
		curveTo( 
			cpStart.x, cpStart.y,
			cpEnd.x, cpEnd.y,
			end.x, end.y
		);
	}
	
	void close( ) {
		subpaths[$-1].close( );
	}
}
