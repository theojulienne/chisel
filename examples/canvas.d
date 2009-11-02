module canvas;

version (Tango) {
	import tango.math.Math;
} else {
	import std.math;
}


import chisel.core.all;
import chisel.graphics.all;
import chisel.text.all;
import chisel.ui.all;

class CanvasView : View {
	Font font;
	String renderText;
	FormattedString fmtString;
	
	this( ) {
		super( );
		
		font = Font.createWithName( "Verdana", 15 );
		
		renderText = String.fromUTF8( "Aa Bb Cc Dd Ee Ff Gg Hh Ii Jj" );
		
		fmtString = FormattedString.createWithString( renderText );
		
		fmtString.setFont( fmtString.range, font );
		
		fmtString.setFont( Range( 0, 8 ), Font.createWithName( "Courier New", font.size ) );
		fmtString.setFont( Range( 9, 8 ), Font.createWithName( "Times New Roman", font.size ) );
	}
	
	void drawRect( GraphicsContext context, Rect dirtyRect ) {
		//Stdout.formatln( "dirty! {}, {} ({},{} {}x{})", this, context, dirtyRect.origin.x, dirtyRect.origin.y, dirtyRect.size.width, dirtyRect.size.height );
		
		//context.drawText( "☃" );
		
		context.yIncreasesUp = false;
		
		Point point = Point( 0, 0 );
		float numLines = (frame.size.height / font.size) + 1;
		for ( int i = 0; i < numLines; i++ ) {
			point.y += font.size;
			context.drawFormattedString( fmtString, point );
		}
		
		Path p = new Path;
		p.moveTo( 0, 100 );
		p.lineTo( 0, 0 );
		p.lineTo( 100, 0 );
		
		context.stroke( p );
		
		Path curve = new Path;
		curve.moveTo( 0, 0 );
		for ( float x = 0; x < 10; x+=1 ) {
			curve.lineTo( x*100, sin(x)*100 );
		}
		
		context.stroke( curve );
	}
}

class CanvasApp : Application {
	Window mainWindow;
	
	this( ) {
		mainWindow = new Window( "Canvas Example" );
		mainWindow.setSize( 500, 500 );
		
		mainWindow.onClose += {
			stop( );
		};
		
		mainWindow.contentView = new CanvasView;
		
		mainWindow.show( );
	}
}

int main( char[][] args ) {
	auto app = new CanvasApp( );
	app.run( );
	
	return 0;
}

