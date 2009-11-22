module hypotrochoid;

version (Tango) {
	import tango.math.Math;
} else {
	import std.math;
}


import chisel.core.all;
import chisel.graphics.all;
import chisel.text.all;
import chisel.ui.all;


class Hypotrochoid {
	
	real bigR, littleR, distance;
	
	this( real bigR, real littleR, real distance ) {
		this.bigR = bigR;
		this.littleR = littleR;
		this.distance = distance;
	}
	
	Path getPath( int iterations, real stepSize ) {

		Path p = new Path( );
		bool first = true;
		
		for ( real theta = 0; theta < iterations; theta+=stepSize ) {
			real x = (bigR - littleR) * cos( theta ) + distance * cos( theta * ((bigR - littleR)/littleR) );
			real y = (bigR - littleR) * sin( theta ) - distance * sin( theta * ((bigR - littleR)/littleR) );
			
			if ( first ) {
				p.moveTo( x, y );
				first = false;
			} else {
				p.lineTo( x, y );
			}
		}
		
		return p;
	}
	
}

class CanvasView : View {
	
	static real initialBigR = 200;
	static real initialLittleR = 80;
	static real initialDistance = 100;
	static real initialStepSize = 0.1;
	static int  initialIterations = 13;
	
	Hypotrochoid hypo;
	
	int iterations;
	real stepSize;
	
	this( ) {
		super( );
		
		hypo = new Hypotrochoid( initialBigR, initialLittleR, initialDistance );
		stepSize = initialStepSize;
		iterations = initialIterations;
	}
	
	void drawRect( GraphicsContext context, Rect dirtyRect ) {
		
		context.yIncreasesUp = true;
	
		context.saveGraphicsState( );

		double height = frame.size.height;
		double width = frame.size.width;
		
		context.translate( width/2, height/2 );
		
		context.stroke( hypo.getPath( iterations, stepSize ) );
		
		context.restoreGraphicsState( );
	}
}

class CanvasApp : Application {
	Window mainWindow;
	
	Slider sliderBigR, sliderLittleR, sliderD;
	
	Slider sliderIterations, sliderStepSize;
	
	CanvasView canvas;
	
	this( ) {
		mainWindow = new Window( "Canvas Drawing Example" );
		mainWindow.setSize( 800, 500 );
		
		mainWindow.onClose += &stop;
		
		auto split = new SplitView( SplitterStacking.Horizontal );
		
		canvas = new CanvasView;
		
		split.addSubview( canvas );
		
		auto rightView = new StackView( );
		rightView.direction = StackDirection.Vertical;
		rightView.padding = 5;
		
		
		auto parameterFrame = new Frame( );
		parameterFrame.title = "Parameters";
		
		
		auto parameterView = new StackView( );
		parameterView.direction = StackDirection.Vertical;
		parameterView.padding = 5;
		
		parameterView.addSubview( new Label( "R:" ) );
		
		sliderBigR = new Slider( SliderType.Horizontal );
		sliderBigR.minValue = 1;
		sliderBigR.maxValue = 500;
		sliderBigR.onChange += &updateParameters;
		
		sliderBigR.value = CanvasView.initialBigR;
		
		parameterView.addSubview( sliderBigR );
		
		parameterView.addSubview( new Label( "r:" ) );
		
		sliderLittleR = new Slider( SliderType.Horizontal );
		sliderLittleR.minValue = 1;
		sliderLittleR.maxValue = 500;
		sliderLittleR.onChange += &updateParameters;
		
		sliderLittleR.value = CanvasView.initialLittleR;
		
		parameterView.addSubview( sliderLittleR );
		
		parameterView.addSubview( new Label( "d:" ) );
		
		sliderD = new Slider( SliderType.Horizontal );
		sliderD.minValue = 1;
		sliderD.maxValue = 500;
		sliderD.onChange += &updateParameters;
		
		sliderD.value = CanvasView.initialDistance;
		
		parameterView.addSubview( sliderD );

		parameterFrame.contentView = parameterView;
		
		rightView.addSubview( parameterFrame );
		
		auto optionsFrame = new Frame( );
		optionsFrame.title = "Drawing Options";
		
		auto optionsView = new StackView( );
		optionsView.direction = StackDirection.Vertical;
		optionsView.padding = 5;
		
		optionsView.addSubview( new Label( "Iterations:" ) );
		
		sliderIterations = new Slider( SliderType.Horizontal );
		sliderIterations.minValue = 1;
		sliderIterations.maxValue = 2000;
		sliderIterations.onChange += &updateParameters;
		
		sliderIterations.value = cast(real)CanvasView.initialIterations;
		
		optionsView.addSubview( sliderIterations );
		
		optionsView.addSubview( new Label( "Angle Step Size:" ) );
		
		sliderStepSize = new Slider( SliderType.Horizontal );
		sliderStepSize.minValue = 0.01;
		sliderStepSize.maxValue = 3.14/4.0;
		sliderStepSize.onChange += &updateParameters;
		
		sliderStepSize.value = CanvasView.initialStepSize;
		
		optionsView.addSubview( sliderStepSize );
		
		optionsFrame.contentView = optionsView;
		
		rightView.addSubview( optionsFrame );
		
		split.addSubview( rightView );
		
		mainWindow.contentView = split;
		
		split.setDividerPosition( 0, 600 );
		
		mainWindow.show( );
	}
	
	void updateParameters( ) {
		canvas.hypo.bigR = sliderBigR.value;
		canvas.hypo.littleR = sliderLittleR.value;
		canvas.hypo.distance = sliderD.value;
		
		canvas.iterations = cast(int)sliderIterations.value;
		canvas.stepSize = sliderStepSize.value;
		
		canvas.invalidate;
	}
	
}

int main( char[][] args ) {
	auto app = new CanvasApp( );
	app.run( );
	
	return 0;
}

