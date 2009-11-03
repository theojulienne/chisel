module glcube;

import chisel.core.all;
import chisel.graphics.all;
import chisel.ui.all;

import chisel.ui.opengl;
import chisel.ui.openglu;

import tango.time.Time;
import tango.time.Clock;

class CubeView : OpenGLView {
	float rquad = 0;
	
	Time startTime;
	float axisX = 1.0;
	float axisY = 0.0;
	float axisZ = 0.0;
	
	float angleX = 0.0;
	float angleY = 0.0;
	float angleZ = 0.0;
	
	float secondsSinceStart = 0.0;
	
	this( ) {
		startTime = Clock.now;
		super( );
	}
	
	this( Rect frame ) {
		startTime = Clock.now;
		super( frame );
	}
	
	void reshape( ) {
		Size size = this.frame.size;
		
		printf( "resize %dx%d\n", size.width, size.height );
		
		glClearColor( 0.0f, 0.0f, 0.0f, 0.0f );

		glViewport( 0, 0, cast(int)size.width, cast(int)size.height );

		glMatrixMode( GL_PROJECTION );
		glLoadIdentity();

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
		
		glDisable(GL_CULL_FACE);
	}
	
	void drawRect( GraphicsContext context, Rect dirtyRect ) {
		OpenGLContext glContext = openGLContext;

		
		glEnable(GL_CULL_FACE);
		glCullFace(GL_BACK);
		
		glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
		
		// draw the cube
		glLoadIdentity();
		glTranslatef( 0.0f, 0.0f, -7.0f );
		
		
		float newSecondsSinceStart = (Clock.now-startTime).millis/1000.0;
		
		float frameDelta = newSecondsSinceStart - secondsSinceStart;
		
		secondsSinceStart = newSecondsSinceStart;
		
		float angle;
		
		// 360 degree rotations in each axis at 90 degrees a second
		if ( axisX == 1.0 ) {
			angleX += frameDelta * 90; //degrees per second
			angle = angleX;
			
			if ( angle > 360 ) {
				axisX = 0.0;
				axisY = 1.0;
				angleX = 0.0;
			}
		} else if ( axisY == 1.0 ) {
			angleY += frameDelta * 90;
			angle = angleY;
			
			if ( angle > 360 ) {
				axisY = 0.0;
				axisZ = 1.0;
				angleY = 0.0;
			}
		} else {
			angleZ += frameDelta * 90;
			angle = angleZ;
			
			if ( angle > 360 ) {
				axisZ = 0.0;
				axisX = 1.0;
				angleZ = 0.0;
			}
		}
		
		// first put the cube on a tilt so it looks cooler
		glRotatef( 45, 1.0, 1.0, 1.0 );
		
		glRotatef( angle, axisX, axisY, axisZ );
		
		
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
		
		//rquad -= 0.015;
		
		glFlush( );
	}
}

class GLCubeApp : Application {
	Window mainWindow;
	CubeView glView;
	
	this( ) {
		mainWindow = new Window( "Chisel Examples - GL Cube" );
		mainWindow.setSize( 800, 600 );
		
		mainWindow.onClose += &closeApp;
		
		glView = new CubeView( Rect( 0, 0, 800, 600 ) );
		mainWindow.contentView = glView; //.addSubview( glView );
		
		mainWindow.show( );
		
		this.useIdleTask = true;
	}
	
	void idleTask( ) {
		glView.invalidate( );
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

