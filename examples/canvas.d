module canvas;

import std.math;

import chisel.core.all;
import chisel.graphics.all;
import chisel.text.all;
import chisel.ui.all;

class CanvasView : View {
	Font font;
	String renderText;
	
	this( ) {
		super( );
		
		font = Font.createWithName( "Verdana", 42 );
		
		renderText = String.fromUTF8( "Aa Bb Cc Dd Ee Ff Ggg Hh Ii Jj" );
	}
	
	void drawRect( GraphicsContext context, CLRect dirtyRect ) {
		//Stdout.formatln( "dirty! {}, {} ({},{} {}x{})", this, context, dirtyRect.origin.x, dirtyRect.origin.y, dirtyRect.size.width, dirtyRect.size.height );
		
		//context.drawText( "☃" );
		
		context.yIncreasesUp = false;
		
		
		
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

