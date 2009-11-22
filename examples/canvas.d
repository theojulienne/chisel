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
			fmtString.drawToContext( context, point );
		}
		
		context.saveGraphicsState( );
		
		context.translate( 250, 0 );
		double height = frame.size.height;
		double availableWidth = frame.size.width - 250;
		
		Path p = new Path;
		p.moveTo( 0, 0 );
		p.lineTo( 0, height );
		p.moveTo( 0, height/2 );
		p.lineTo( frame.size.width, height/2 );
		
		context.stroke( p );
		
		void displayFunc( real function(real) func ) {
			Path curve = new Path;
			curve.moveTo( 0, 0 );
			float maxX = 3.142 * 4;
			double scaler = height/2;
			for ( float x = 0; x <= maxX; x+=0.01 ) {
				float val = func(x);
				curve.lineTo( x/maxX*(availableWidth), (1-val)*scaler );
			}
		
			context.stroke( curve );
		}
		
		context.strokeColor = Color( 1.0, 0.0, 0.0, 1.0 );
		displayFunc( &sin );
		context.strokeColor = Color( 0.0, 0.0, 1.0, 1.0 );
		displayFunc( &cos );
		
		context.restoreGraphicsState( );
	}
}

class CanvasApp : Application {
	Window mainWindow;
	
	this( ) {
		mainWindow = new Window( "Canvas Example" );
		mainWindow.setSize( 800, 500 );
		
		mainWindow.onClose += &stop;
		
		mainWindow.contentView = new CanvasView;
		
		mainWindow.show( );
	}
}

int main( char[][] args ) {
	auto app = new CanvasApp( );
	app.run( );
	
	return 0;
}

