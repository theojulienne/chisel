module glcube;

import chisel.core.all;
import chisel.graphics.all;
import chisel.ui.all;

import chisel.ui.opengl;
import chisel.ui.openglu;

import tango.time.Time;
import tango.time.Clock;

import tango.stdc.stdlib;

class Star {
	float x, y;
	float vx, vy;
}

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
	
	int numStars = 150;
	
	Star[] stars;
	
	void init( ) {
		startTime = Clock.now;
		stars.length = numStars;
		
		float stretch = 10;
		for ( int i = 0; i < stars.length; i++ ) {
			stars[i] = new Star( );

			stars[i].x = stretch * (rand( ) % 1000) / 1000.0f - stretch/2.0;
			stars[i].y = stretch * (rand( ) % 1000) / 1000.0f - stretch/2.0;
			stars[i].vx = (rand( ) % 50) / 1000.0f + 0.01;
			stars[i].vy = 0.0;
		}
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
		
		glDisable(GL_CULL_FACE);
	}
	
	void drawRect( GraphicsContext context, Rect dirtyRect ) {
		float newSecondsSinceStart = (Clock.now-startTime).millis/1000.0;
		
		float frameDelta = newSecondsSinceStart - secondsSinceStart;
		
		OpenGLContext glContext = openGLContext;
		
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		
		
		glEnable(GL_CULL_FACE);
		glCullFace(GL_BACK);
		
		glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
		
		glLoadIdentity();
		glTranslatef( 0.0f, 0.0f, -7.0f );

		// fake a starfield in the background
		foreach ( star; stars ) {
			star.x += star.vx*frameDelta*60.0;
			star.y += star.vy*frameDelta*60.0;
			if ( star.x < 5 ) {
				glBegin( GL_LINE_STRIP );
				glColor3ub( 0, 0, 0 );
				glVertex3f( star.x-star.vx*4, star.y-star.vy*4, 1.0f );
				glColor3ub( 255, 255, 255 );
				glVertex3f( star.x, star.y, 1.0f );
				glEnd();
			} else {
				star.x = -5;
			}
		}
		
		
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

