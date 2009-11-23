module glcube;

import chisel.core.all;
import chisel.graphics.all;
import chisel.ui.all;

import chisel.ui.opengl;
import chisel.ui.openglu;

import tango.stdc.stdlib;

class CubeView : OpenGLView {
	float angleX = 0.0;
	float angleY = 0.0;
	float angleZ = 0.0;
	
	void init( ) {
		
	}
	
	this( ) {
		super( );
		
		init( );
	}
	
	this( Rect frame ) {
		super( frame );
		
		init( );
	}
	
	void reshape( ) {
		Size size = this.frame.size;
		
		printf( "resize %fx%f\n", size.width, size.height );
		
		glClearColor( 0.0f, 0.0f, 0.0f, 0.0f );

		glViewport( 0, 0, cast(int)size.width, cast(int)size.height );

		glMatrixMode( GL_PROJECTION );
		glLoadIdentity( );

		float aspect = size.width / size.height;

		gluPerspective( 50.0, aspect, 0.1f, 100.0f );

		glMatrixMode( GL_MODELVIEW );
		glLoadIdentity();

		glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glEnable(GL_DEPTH_TEST);
		glClearDepth(1.0);
		glDepthFunc(GL_LEQUAL);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glEnable(GL_BLEND);
		glAlphaFunc(GL_GREATER,0.01);
		glEnable(GL_ALPHA_TEST);				
		glEnable(GL_TEXTURE_2D);

		glEnable(GL_POINT_SMOOTH);
		glEnable(GL_LINE_SMOOTH);
		glEnable(GL_POLYGON_SMOOTH);
	}
	
	void drawRect( GraphicsContext context, Rect dirtyRect ) {

		OpenGLContext glContext = openGLContext;
		
		glLoadIdentity();
		
		glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
		
		glLoadIdentity();
		glTranslatef( 0.0f, 0.0f, -7.0f );

		// first put the cube on a tilt so it looks cooler
		//glRotatef( 45, 1.0, 1.0, 1.0 );
		
		double max = 360;
		
		glRotatef( max*angleX, 1.0f, 0.0f, 0.0f );
		glRotatef( max*angleY, 0.0f, 1.0f, 0.0f );
		glRotatef( max*angleZ, 0.0f, 0.0f, 1.0f );
		
		
		// draw the cube
		glBegin( GL_QUADS );
		
		glColor3f( 0.0f, 1.0f, 0.0f );
		glVertex3f( 1.0f, 1.0f,-1.0f);
		glVertex3f(-1.0f, 1.0f,-1.0f);
		glVertex3f(-1.0f, 1.0f, 1.0f);
		glVertex3f( 1.0f, 1.0f, 1.0f);
		
		glColor3f(1.0f,0.5f,0.0f);
		glVertex3f( 1.0f,-1.0f, 1.0f);
		glVertex3f(-1.0f,-1.0f, 1.0f);
		glVertex3f(-1.0f,-1.0f,-1.0f);
		glVertex3f( 1.0f,-1.0f,-1.0f);
		
		glColor3f(1.0f,0.0f,0.0f);
		glVertex3f( 1.0f, 1.0f, 1.0f);
		glVertex3f(-1.0f, 1.0f, 1.0f);
		glVertex3f(-1.0f,-1.0f, 1.0f);
		glVertex3f( 1.0f,-1.0f, 1.0f);
		
		glColor3f(1.0f,1.0f,0.0f);
		glVertex3f( 1.0f,-1.0f,-1.0f);
		glVertex3f(-1.0f,-1.0f,-1.0f);
		glVertex3f(-1.0f, 1.0f,-1.0f);
		glVertex3f( 1.0f, 1.0f,-1.0f);
		
		glColor3f(0.0f,0.0f,1.0f);
		glVertex3f(-1.0f, 1.0f, 1.0f);
		glVertex3f(-1.0f, 1.0f,-1.0f);
		glVertex3f(-1.0f,-1.0f,-1.0f);
		glVertex3f(-1.0f,-1.0f, 1.0f);
		
		glColor3f(1.0f,0.0f,1.0f);
		glVertex3f( 1.0f, 1.0f,-1.0f);
		glVertex3f( 1.0f, 1.0f, 1.0f);
		glVertex3f( 1.0f,-1.0f, 1.0f);
		glVertex3f( 1.0f,-1.0f,-1.0f);
		
		glEnd();
		
		glContext.flushBuffer( );
	}
}

class GLCubeApp : Application {
	Window mainWindow;
	CubeView glView;
	
	Slider sliderX, sliderY, sliderZ;
	
	this( ) {
		mainWindow = new Window( "Chisel Examples - GL Cube" );
		mainWindow.setSize( 1000, 600 );
		
		mainWindow.onClose += &closeApp;
		
		glView = new CubeView( Rect( 0, 0, 800, 600 ) );
		
		auto split = new SplitView( SplitterStacking.Horizontal );
		
		split.addSubview( glView );
		
		auto rightView = new StackView( StackDirection.Vertical );
		rightView.padding = 5;
		
		auto rotateView = new Frame( );
		rotateView.title = "Cube Rotation";
		
		rightView.addSubview( rotateView );
		
		auto rotatePropsView = new StackView( StackDirection.Vertical );
		rotatePropsView.padding = 5;
		
		rotateView.contentView = rotatePropsView;
		
		rotatePropsView.addSubview( new Label( "Pitch (X)" ) );
		
		sliderX = new Slider( SliderType.Horizontal );
		sliderX.minValue = 0;
		sliderX.maxValue = 1;
		sliderX.onChange += &sliderChanged;
		rotatePropsView.addSubview( sliderX );
		
		rotatePropsView.addSubview( new Label( "Yaw (Y)" ) );
		
		sliderY = new Slider( SliderType.Horizontal );
		sliderY.minValue = 0;
		sliderY.maxValue = 1;
		sliderY.onChange += &sliderChanged;
		rotatePropsView.addSubview( sliderY );
		
		rotatePropsView.addSubview( new Label( "Roll (Z)" ) );
		
		sliderZ = new Slider( SliderType.Horizontal );
		sliderZ.minValue = 0;
		sliderZ.maxValue = 1;
		sliderZ.onChange += &sliderChanged;
		rotatePropsView.addSubview( sliderZ );
		
		auto resetButton = new Button( "Reset" );
		resetButton.onPress += &resetAngles;
		rotatePropsView.addSubview( resetButton );
		
		split.addSubview( rightView );
		
		mainWindow.contentView = split;
		
		split.setDividerPosition( 0, 800 );
		
		mainWindow.show( );
		
		this.useIdleTask = true;
	}
	
	void sliderChanged( ) {
		glView.angleX = sliderX.value;
		glView.angleY = sliderY.value;
		glView.angleZ = sliderZ.value;
		
		glView.invalidate( );
	}
	
	void resetAngles( ) {
		sliderX.value = 0;
		sliderY.value = 0;
		sliderZ.value = 0;
		
		sliderChanged( );
	}
	
	void closeApp( ) {
		stop( );
	}
}

int main( char[][] args ) {
	auto app = new GLCubeApp( );
	app.run( );
	
	return 0;
}

