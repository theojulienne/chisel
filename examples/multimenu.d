module multimenu;

import chisel.core.all;
import chisel.ui.all;

version (Tango) {
	import tango.io.Stdout;
}

class MultiMenuApp : Application {
	int numWindows = 0;
	
	this( ) {
		applicationName = "Chisel Menus";
		
		makeWindow( "Example 1" );
		makeWindow( "Example 2" );
		makeWindow( "Example 3" );
	}
	
	void makeWindow( unicode name ) {
		Window mainWindow = new Window( name );
		mainWindow.setSize( 300, 300 );
		
		MenuBar menubar = new MenuBar( );
		
		MenuItem mi = new MenuItem( "File" );
		Menu exampleSub = new Menu( );
		mi.submenu = exampleSub;
		exampleSub.appendItem( new MenuItem( "Foo" ) );
		menubar.appendItem( mi );
		
		MenuItem mi2 = new MenuItem( "Example ("~name~")" );
		Menu exampleSub2 = new Menu( );
		mi2.submenu = exampleSub2;
		exampleSub2.appendItem( new MenuItem( "Foo" ) );
		menubar.appendItem( mi2 );
		
		mainWindow.menubar = menubar;
		
		//myButton.onPress += &printAction!( "Button Pressed!" );
		
		mainWindow.onClose += &onWindowCloses;
		
		mainWindow.show( );
		
		numWindows++;
	}
	
	void printAction( unicode description )( ) {
		version (Tango) {
			Stdout.formatln( "Action: {}", description );
		}
	}
	
	void onWindowCloses( ) {
		numWindows--;
		
		if ( numWindows == 0 ) {
			stop( );
		}
	}
}

int main( char[][] args ) {
	auto app = new MultiMenuApp( );
	app.run( );
	
	return 0;
}

