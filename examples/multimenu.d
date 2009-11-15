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
		
		MenuItem fileItem = new MenuItem( "File" );
		Menu fileMenu = new Menu( );
		fileItem.submenu = fileMenu;
		menubar.appendItem( fileItem );
		
		MenuItem addWithEvent( unicode title, unicode keyEquiv="" ) {
			MenuItem item = new MenuItem( title, keyEquiv );
			
			item.onPress += &menuItemPressed;
			
			fileMenu.appendItem( item );
			
			return item;
		}
		
		addWithEvent( "New", "n" );
		addWithEvent( "Open", "o" );
		fileMenu.appendItem( MenuItem.separatorItem );
		addWithEvent( "Close", "w" );
		addWithEvent( "Save", "s" );
		auto saveAsItem = addWithEvent( "Save As...", "s" );
		saveAsItem.addModifier( ModifierKey.Shift );
		
		MenuItem mi2 = new MenuItem( "Example ("~name~")" );
		Menu exampleSub2 = new Menu( );
		mi2.submenu = exampleSub2;
		exampleSub2.appendItem( new MenuItem( "Foo" ) );
		menubar.appendItem( mi2 );
		
		mainWindow.menubar = menubar;
		
		mainWindow.onClose += &onWindowCloses;
		
		mainWindow.show( );
		
		numWindows++;
	}
	
	void menuItemPressed( Event e ) {
		MenuItem menuItem = cast(MenuItem)e.target;
		assert( menuItem !is null );
		
		version (Tango) {
			Stdout.formatln( "Action on menu item: {}", menuItem.title.dString );
		}
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

