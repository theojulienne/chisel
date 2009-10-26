module helloworld;

import chisel.core.all;
import chisel.ui.all;

class HelloWorldApp : Application {
	Window mainWindow;
	
	this( ) {
		mainWindow = new Window( "Hello, ☃!" );
		mainWindow.setSize( 500, 500 );
		
		mainWindow.onClose += {
			stop( );
		};
		
		mainWindow.show( );
	}
}

int main( char[][] args ) {
	auto app = new HelloWorldApp( );
	app.run( );
	
	return 0;
}

