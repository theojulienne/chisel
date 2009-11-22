module chisel.graphics.path;

import chisel.core.all;
import chisel.graphics.all;

import chisel.graphics.types;

enum PathCommand {
	MoveTo,
	LineTo,
	CurveTo,
	Close,
}

struct PathSegment {
	PathCommand command;
	CLFloat[] items;
}

class Path {
	SubPath[] subpaths;
	
	this( ) {
		subpaths ~= new SubPath;
	}
	
	class SubPath {
		PathSegment[] segments;
		
		bool isEmpty( ) {
			return segments.length == 0;
		}
		
		void moveTo( CLFloat x, CLFloat y ) {
			PathSegment seg;
			seg.command = PathCommand.MoveTo;
			seg.items = [x, y];
			segments ~= seg;
		}
		
		void lineTo( CLFloat x, CLFloat y ) {
			PathSegment seg;
			seg.command = PathCommand.LineTo;
			seg.items = [x, y];
			segments ~= seg;
		}
		
		void curveTo( CLFloat cp1X, CLFloat cp1Y, CLFloat cp2X, CLFloat cp2Y, CLFloat endX, CLFloat endY ) {
			PathSegment seg;
			seg.command = PathCommand.CurveTo;
			seg.items = [cp1X, cp1Y, cp2X, cp2Y, endX, endY];
			segments ~= seg;
		}
		
		void close( ) {
			PathSegment seg;
			seg.command = PathCommand.Close;
			segments ~= seg;
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
	
	void moveTo( Point point ) {
		moveTo( point.x, point.y );
	}
	
	void lineTo( CLFloat x, CLFloat y ) {
		subpaths[$-1].lineTo( x, y );
	}
	
	void lineTo( Point point ) {
		lineTo( point.x, point.y );
	}
	
	void curveTo( CLFloat cp1X, CLFloat cp1Y, CLFloat cp2X, CLFloat cp2Y, CLFloat endX, CLFloat endY ) {
		subpaths[$-1].curveTo( cp1X, cp1Y, cp2X, cp2Y, endX, endY );
	}
	
	void curveTo( Point cpStart, Point cpEnd, Point end ) {
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
