module racer;

import chisel.core.all;
import chisel.graphics.all;
import chisel.ui.all;
import chisel.text.all;

import chisel.ui.opengl;
import chisel.ui.openglu;


version (Tango) {
	import tango.io.Stdout;
}

// Tango is weird...
import tango.time.Time;
import tango.time.Clock;
import tango.time.WallClock;
import tango.math.Math;

import tango.stdc.stdlib;


class Cube {
	float x;
	float y;
	float z;
	
	float pitch = 0;
	float yaw   = 0;
	float roll  = 0;
	
	float size = 1.0;
	
	this( float x, float y, float z ) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	float distanceTo( float x, float y, float z ) {
		float dx = this.x - x;
		float dy = this.y - y;
		float dz = this.z - z;
		
		float distance = sqrt( (dx*dx) + (dy*dy) + (dz*dz) );
		
		return distance;
	}
	
	void render( ) {
		glPushMatrix();
		
		glTranslatef( x, y, z );
		
		
		glScalef( size, size, size );

		double max = 360;

		glRotatef( pitch, 1.0f, 0.0f, 0.0f );
		glRotatef( yaw,   0.0f, 1.0f, 0.0f );
		glRotatef( roll,  0.0f, 0.0f, 1.0f );

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
		
		glPopMatrix();
	}
	
}

class RacerView : OpenGLView {

	Cube[] cubeField;
	
	Time startTime;
	
	float secondsSinceStart = 0.0;
	
	double steer = 0.0;

	double x, y, z;
	
	double vx, vy, vz;
	
	double steerSpeed = 5.0;
	
	double g = 9.8;
	
	double ground = -0.5;
	
	double cubeSize = 0.25;
	
	int numCubes = 50;
	
	int fieldWidth = 10;
	
	double progress( ) {
		return (z / numCubes);
	}

	void init( ) {
		startTime = Clock.now;
		srand( WallClock.now.time.seconds );
		cubeField.length = numCubes;
		
		newLevel( );
	}

	void newLevel( ) {
		this.x = 0.0;
		this.y = ground;
		this.z = 0.0;
		
		this.vx = 0.0;
		this.vy = 0.0;
		this.vz = 2.5; // whee
		
		for ( int i = 0; i < numCubes; i++ ) {
			float x = cast(float) (rand() % fieldWidth - fieldWidth/2);
			float z = cast(float) (rand() % numCubes);
			cubeField[i] = new Cube( x, 0.0, z-numCubes );
			cubeField[i].size = cubeSize;
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
		
		glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);

		glEnable(GL_POINT_SMOOTH);
		glEnable(GL_LINE_SMOOTH);
		glEnable(GL_POLYGON_SMOOTH);
	}

	void drawRect( GraphicsContext context, Rect dirtyRect ) {

		float newSecondsSinceStart = (Clock.now-startTime).millis/1000.0;
		
		float frameDelta = newSecondsSinceStart - secondsSinceStart;
		
		secondsSinceStart = newSecondsSinceStart;
		
		this.vx = steer * steerSpeed;
		
		this.z += frameDelta * vz;
		
		
		if ( this.x < -fieldWidth/2 ) {
			this.x = -fieldWidth/2;
		}
		
		if ( this.x > fieldWidth/2 ) {
			this.x = fieldWidth/2;
		}
			
		this.x += frameDelta * vx;
		

		this.y -= frameDelta * this.vy;
		
		if ( this.y < ground ) {
			this.vy -= g * frameDelta;
		} else {
			this.vy = 0.0;
			this.y = ground;
		}

		
		OpenGLContext glContext = openGLContext;

		glLoadIdentity();

		glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

		glTranslatef( x, y, z );

		bool ouch = false;
		
		foreach ( cube; cubeField ) {
			//Stdout.formatln( "{}", cube.distanceTo( -x, y-ground, -z ) );
			if ( cube.distanceTo( -x, y-ground, -z ) < 0.8 ) {
				cube.y += 1.0;
				ouch = true;
			}
			cube.render( );
		}
		
		glContext.flushBuffer( );

		if ( ouch ) {
			this.z = 0.0;
		}

	}
}


class RacerApp : Application {
	Window mainWindow;
	
	RacerView racer;
	
	StackView groupStackView;
	
	View[unicode] groups;
	
	ProgressBar levelProgress;
	
	ProgressBar raceProgress;
	
	Label level;
	
	bool win = false;
	
	this( ) {
		applicationName = "Chisel Racer";
		
		mainWindow = new Window( "Chisel Racer" );
		mainWindow.setSize( 300, 500 );
		
		MenuBar menubar = new MenuBar( );
		
		MenuItem mi = new MenuItem( "Game" );
		Menu exampleSub = new Menu( );
		mi.submenu = exampleSub;
		exampleSub.appendItem( new MenuItem( "New Game" ) );
		menubar.appendItem( mi );
		
		mainWindow.menubar = menubar;
		
		
		// create a stack of groups
		groupStackView = new StackView( );
		groupStackView.direction = StackDirection.Vertical;
		groupStackView.padding = 15;
		
		// create our groups
		createGroup( "race", "Level" );
		createGroup( "control", "Controls" );
		
		// level
		level = new Label( "Dodge the Squares!!!" );
		groups["race"].addSubview( level );
		
		// game view
		racer = new RacerView( Rect( 0, 0, 400, 200 ) );
		groups["race"].addSubview( racer );
		
		// level progress
		levelProgress = new ProgressBar( ProgressBarType.Horizontal );
		levelProgress.indeterminate = false;
		levelProgress.value = 0;
		groups["race"].addSubview( levelProgress );
		
		raceProgress = new ProgressBar( ProgressBarType.Horizontal );
		raceProgress.indeterminate = false;
		raceProgress.value = 0;
		groups["race"].addSubview( raceProgress );	
		
		// controls:
		
		// jump
		Button jumpButton = new Button( "Jump" );
		jumpButton.onPress += &jump;
		groups["control"].addSubview( jumpButton );
		
		// steer
		Slider steering = new Slider( SliderType.Horizontal );
		steering.value = 0.5;
		steering.onChange += &steer;
		groups["control"].addSubview( steering );
		
		mainWindow.contentView = groupStackView;
		
		mainWindow.onClose += &onWindowCloses;
		
		mainWindow.show( );
		
		
		this.useIdleTask = true;
	}

	void idleTask( ) {
		if ( !win ) {
			racer.invalidate( );
			levelProgress.value = racer.progress;
		
			if ( levelProgress.value == 1.0 ) {
				racer.newLevel( );
				raceProgress.value = raceProgress.value + 0.1;
			}
		
			if ( raceProgress.value == 1.0 ) {
				level.text = "Win!!!";
				win = true;
			}
		}
	}
	
	void steer( Event event ) {
		Slider steering = cast(Slider)event.target;
		racer.steer = (steering.value * 2.0) - 1.0; // 0 -> -1, 0.5 -> 0, 1 -> 1
	}
	
	void jump( ) {
		racer.vy = 6; // 6 m/s
	}
	
	void createGroup( unicode code, unicode title ) {
		// start by creating a frame
		auto groupFrame = new Frame( );
		groupFrame.title = title;
		
		groupStackView.addSubview( groupFrame );
		
		// create a stack for this group
		auto groupStack = new StackView( );
		groupStack.direction = StackDirection.Vertical;
		groupStack.padding = 10;
		
		groupFrame.contentView = groupStack;
		
		// add the group
		groups[code] = groupStack;
	}
	
	void onWindowCloses( ) {
		stop( );
	}
}

int main( char[][] args ) {
	auto app = new RacerApp( );
	app.run( );
	
	return 0;
}

