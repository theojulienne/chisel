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


class Color {
	float red;
	float green;
	float blue;
	
	this( float r, float g, float b ) {
		red = r;
		green = g;
		blue = b;
	}
	
	void glApply() {
		glColor3f( red, green, blue );
		/*
		float[] materialColor = [ red, green, blue, 1 ];
		float[] materialEmission = [ 0, 0, 0, 1 ];
		float[] materialSpecular = [ 0.1, 0.1, 0.1, 1 ];
		
		// setting any of these makes the rotating cube not update the lighting
		glMaterialfv(GL_FRONT, GL_DIFFUSE, cast(float*)materialColor);
		glMaterialfv(GL_FRONT, GL_AMBIENT, cast(float*)materialColor);
		glMaterialfv(GL_FRONT, GL_SPECULAR, cast(float*)materialSpecular);
		glMaterialfv(GL_FRONT, GL_EMISSION, cast(float*)materialEmission);
		
		glMateriali(GL_FRONT, GL_SHININESS, 90);
		*/
	}
}

class Cube {
	float x;
	float y;
	float z;
	
	float pitch = 0;
	float yaw   = 0;
	float roll  = 0;
	
	float vX, vY, vZ;
	float vPitch, vYaw, vRoll;
	
	float size = 1.0;
	
	Color[] faceColors;
	
	this( float x, float y, float z ) {
		Color[6] faceColors = [
			new Color( 1, 0, 0 ),
			new Color( 1, 1, 0 ),
			new Color( 1, 0, 1 ),
			new Color( 0, 1, 0 ),
			new Color( 0, 1, 1 ),	
			new Color( 0, 0, 1 ),
		];
		
		this( x, y, z, faceColors );
	}
	
	this( float x, float y, float z, Color cubeColor ) {
		Color[6] faceColors;
		for ( int i = 0; i < faceColors.length; i++ ) {
			faceColors[i] = cubeColor;
		}
		
		this( x, y, z, faceColors );
	}
	
	this( float x, float y, float z, Color[] faceColors ) {
		this.x = x;
		this.y = y;
		this.z = z;
		
		vX = 0;
		vY = 0;
		vZ = 0;
		
		vPitch = 0;
		vYaw   = 0;
		vRoll  = 0;
		
		this.faceColors = faceColors.dup;
	}
	
	float distanceTo( float x, float y, float z ) {
		float dx = this.x - x;
		float dy = this.y - y;
		float dz = this.z - z;
		
		float distance = sqrt( (dx*dx) + (dy*dy) + (dz*dz) );
		
		return distance;
	}
	
	void update( float timeDelta ) {
		x += timeDelta * vX;
		y += timeDelta * vY;
		z += timeDelta * vZ;
		
		pitch += timeDelta * vPitch;
		yaw   += timeDelta * vYaw;
		roll  += timeDelta * vRoll;
	}
	
	void render( ) {
		glPushMatrix();
		
		glTranslatef( x, y, z );

		double max = 360;

		glRotatef( pitch, 1.0f, 0.0f, 0.0f );
		glRotatef( yaw,   0.0f, 1.0f, 0.0f );
		glRotatef( roll,  0.0f, 0.0f, 1.0f );

		// draw the cube
		glBegin( GL_QUADS );
		
		//Quad1
		faceColors[0].glApply();
		glNormal3f(1.0f, 0.0f, 0.0f);   //N1
		glTexCoord2f(0.0f, 1.0f); glVertex3f( size/2, size/2, size/2);   //V2
		glTexCoord2f(0.0f, 0.0f); glVertex3f( size/2,-size/2, size/2);   //V1
		glTexCoord2f(1.0f, 0.0f); glVertex3f( size/2,-size/2,-size/2);   //V3
		glTexCoord2f(1.0f, 1.0f); glVertex3f( size/2, size/2,-size/2);   //V4
		//Quad 2
		faceColors[1].glApply();
		glNormal3f(0.0f, 0.0f, -1.0f);  //N2
		glTexCoord2f(0.0f, 1.0f); glVertex3f( size/2, size/2,-size/2);   //V4
		glTexCoord2f(0.0f, 0.0f); glVertex3f( size/2,-size/2,-size/2);   //V3
		glTexCoord2f(1.0f, 0.0f); glVertex3f(-size/2,-size/2,-size/2);   //V5
		glTexCoord2f(1.0f, 1.0f); glVertex3f(-size/2, size/2,-size/2);   //V6
		//Quad 3
		faceColors[2].glApply();
		glNormal3f(-1.0f, 0.0f, 0.0f);  //N3
		glTexCoord2f(0.0f, 1.0f); glVertex3f(-size/2, size/2,-size/2);   //V6
		glTexCoord2f(0.0f, 0.0f); glVertex3f(-size/2,-size/2,-size/2);   //V5
		glTexCoord2f(1.0f, 0.0f); glVertex3f(-size/2,-size/2, size/2);   //V7
		glTexCoord2f(1.0f, 1.0f); glVertex3f(-size/2, size/2, size/2);   //V8
		//Quad 4
		faceColors[3].glApply();
		glNormal3f(0.0f, 0.0f, 1.0f);   //N4
		glTexCoord2f(0.0f, 1.0f); glVertex3f(-size/2, size/2, size/2);   //V8
		glTexCoord2f(0.0f, 0.0f); glVertex3f(-size/2,-size/2, size/2);   //V7
		glTexCoord2f(1.0f, 0.0f); glVertex3f( size/2,-size/2, size/2);   //V1
		glTexCoord2f(1.0f, 1.0f); glVertex3f( size/2, size/2, size/2);   //V2
		//Quad 5
		faceColors[4].glApply();
		glNormal3f(0.0f, 1.0f, 0.0f);   //N5
		glTexCoord2f(0.0f, 1.0f); glVertex3f(-size/2, size/2,-size/2);   //V6
		glTexCoord2f(0.0f, 0.0f); glVertex3f(-size/2, size/2, size/2);   //V8
		glTexCoord2f(1.0f, 0.0f); glVertex3f( size/2, size/2, size/2);   //V2
		glTexCoord2f(1.0f, 1.0f); glVertex3f( size/2, size/2,-size/2);   //V4
		//Quad 6
		faceColors[5].glApply();
		glNormal3f(1.0f, -1.0f, 0.0f);  //N6
		glTexCoord2f(0.0f, 1.0f); glVertex3f(-size/2,-size/2, size/2);   //V7
		glTexCoord2f(0.0f, 0.0f); glVertex3f(-size/2,-size/2,-size/2);   //V5
		glTexCoord2f(1.0f, 0.0f); glVertex3f( size/2,-size/2,-size/2);   //V3
		glTexCoord2f(1.0f, 1.0f); glVertex3f( size/2,-size/2, size/2);   //V1

		glEnd();
		
		glPopMatrix();
	}
	
}

class RacerView : OpenGLView {

	Cube[] cubeField;
	
	Time startTime;
	
	bool wireframe = false;
	
	bool lights = true;
	
	float secondsSinceStart = 0.0;
	
	double steer = 0.0;

	double x, y, z;
	
	double vx, vy, vz;
	
	double steerSpeed = 5.0;
	
	double g = 9.8;
	
	double ground = -0.8;
	
	double cubeSize = 0.5;
	
	int numCubes = 50;
	
	int fieldWidth = 10;
	
	double lightFader = 1.0;
	
	double progress( ) {
		return (z / numCubes);
	}

	void init( ) {
		startTime = Clock.now;
		srand( WallClock.now.time.seconds );
		cubeField.length = numCubes;
		
		newLevel( 0.0 );
	}

	void newLevel( float speed ) {
		this.x = 0.0;
		this.y = ground;
		this.z = 0.0;
		
		this.vx = 0.0;
		this.vy = 0.0;
		this.vz = 2.5 + speed; // whee
		
		for ( int i = 0; i < numCubes; i++ ) {
			float x = cast(float) (rand() % fieldWidth - fieldWidth/2);
			float z = cast(float) (rand() % numCubes);
			
			// pastels :)
			float r = cast(float)(rand() % 128 + 128) / 255;
			float g = cast(float)(rand() % 128 + 128) / 255;
			float b = cast(float)(rand() % 128 + 128) / 255;
			
			
			cubeField[i] = new Cube( x, 0.0, z-numCubes, new Color( r, g, b ) );
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
		
		
		
		// tiny ambient light
		float[] global_ambient = [ 0.2f, 0.2f, 0.2f, 1.0f ];
		glLightModelfv(GL_LIGHT_MODEL_AMBIENT, cast(float*)global_ambient);
		
		glShadeModel(GL_SMOOTH);
		
		
		glEnable(GL_LIGHTING);
		
		glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
		
		glEnable(GL_COLOR_MATERIAL);
		
		
	}

	void drawRect( GraphicsContext context, Rect dirtyRect ) {

		float newSecondsSinceStart = (Clock.now-startTime).millis/1000.0;
		
		float frameDelta = newSecondsSinceStart - secondsSinceStart;
		
		secondsSinceStart = newSecondsSinceStart;
		
		this.vx = steer * steerSpeed;
		
		this.z += frameDelta * vz;
		
		
		if ( this.x < -fieldWidth/2 + 1 ) {
			this.x = -fieldWidth/2 + 1;
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
		
		if ( wireframe ) {
			glPolygonMode( GL_FRONT_AND_BACK, GL_LINE );
		} else {
			glPolygonMode( GL_FRONT_AND_BACK, GL_FILL );
		}
		
		// fade lights		
		if ( lights ) {
			lightFader += frameDelta * 1.0;
		} else {
			lightFader -= frameDelta * 1.0;
		}
		
		// limit lights
		if ( lightFader <= 0.0 ) {
			lightFader = 0;
		} else if ( lightFader >= 1.0 ) {
			lightFader = 1;
		}
		
		
		float[] ambientLight  = [ 0, 0, 0, 1 ];
		float[] diffuseLight  = [ lightFader, lightFader, lightFader, 1 ];
		float[] specularLight = [ 1, 1, 1, 1 ];
		float[] positionLight = [ 0.0f, y*2, 0.0f, 1.0f ];
	
		glLightfv(GL_LIGHT0, GL_SPECULAR, cast(float*)specularLight);
		glLightfv(GL_LIGHT0, GL_DIFFUSE, cast(float*)diffuseLight);
		glLightfv(GL_LIGHT0, GL_AMBIENT, cast(float*)ambientLight);
		glLightfv(GL_LIGHT0, GL_POSITION, cast(float*)positionLight);
		
		glEnable(GL_LIGHT0);
		


		
		glPushMatrix( );
		
		glTranslatef( x, y, z );
		

		bool ouch = false;
		
		foreach ( cube; cubeField ) {
			//Stdout.formatln( "{}", cube.distanceTo( -x, y-ground, -z ) );
			if ( cube.distanceTo( -x, y-ground, -z ) < 0.8 ) {
				//cube.y += 1.0;
				
				// spin (degrees per second)
				// direction hit
				if ( cube.x < x ) {
					cube.vYaw = -180.0;
				} else {
					cube.vYaw = 180.0;
				}
				
				ouch = true;
			}
			cube.update( frameDelta );
			
			cube.render( );
		}
		
		glPopMatrix( );
		
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
		mainWindow.setSize( 550, 640 );
		
		MenuBar menubar = new MenuBar( );
		
		MenuItem mi = new MenuItem( "Game" );
		Menu exampleSub = new Menu( );
		mi.submenu = exampleSub;
		
		MenuItem menuNewGame = new MenuItem( "New Game", "N" );
		menuNewGame.onPress += &newGame;
		exampleSub.appendItem( menuNewGame );
		menubar.appendItem( mi );
		
		mainWindow.menubar = menubar;
		
		
		// create a stack of groups
		groupStackView = new StackView( StackDirection.Vertical );
		groupStackView.padding = 15;
		
		// create our groups
		createGroup( "race", "Level" );
		createGroup( "control", "Controls" );
		
		// level
		level = new Label( "Dodge the Cubes!!!" );
		groups["race"].addSubview( level );
		
		// game view
		racer = new RacerView( Rect( 0, 0, 500, 300 ) );
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
		
		CheckBox wireframeCheckbox = new CheckBox( "Wireframe" );
		wireframeCheckbox.onChange += &checkWireframe;
		groups["control"].addSubview( wireframeCheckbox );
		
		CheckBox lightsCheckbox = new CheckBox( "Lights" );
		lightsCheckbox.checked = true;
		lightsCheckbox.onChange += &checkLights;
		groups["control"].addSubview( lightsCheckbox );
		
		mainWindow.contentView = groupStackView;
		
		mainWindow.onClose += &onWindowCloses;
		
		mainWindow.show( );
		
		
		this.useIdleTask = true;
	}

	void checkWireframe( Event event ) {
		CheckBox checkbox = cast(CheckBox) event.target;
		racer.wireframe = checkbox.checked;
	}

	void checkLights( Event event ) {
		CheckBox checkbox = cast(CheckBox) event.target;
		racer.lights = checkbox.checked;	
	}

	void newGame( ) {
		raceProgress.value = 0.0;
		racer.newLevel( 0.0 );
	}

	void idleTask( ) {
		if ( !win ) {
			racer.invalidate( );
			levelProgress.value = racer.progress;
	
			if ( raceProgress.value == 1.0 ) {
				level.text = "Win!!!";
				win = true;
			}
					
			if ( levelProgress.value == 1.0 ) {
				raceProgress.value = raceProgress.value + 0.1;
				racer.newLevel( raceProgress.value * 2.5 ); // 2.5 * 0.1 increase in speed each level
			}

		}
	}
	
	void steer( Event event ) {
		Slider steering = cast(Slider)event.target;
		racer.steer = -((steering.value * 2.0) - 1.0); // 0 -> -1, 0.5 -> 0, 1 -> 1
	}
	
	void jump( ) {
		if ( racer.y >= racer.ground ) {
			// on the ground
			racer.vy = 6; // 6 m/s
		}
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

