module dialogs;

import chisel.core.all;
import chisel.graphics.all;
import chisel.ui.all;

version (Tango) {
	import tango.io.Stdout;
}

class DialogsApp : Application {
	Window mainWindow;
	
	this( ) {
		applicationName = "Chisel Dialogs";
		
		mainWindow = new Window( "Dialog Example" );
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
		auto openItem = addWithEvent( "Open", "o" );
		openItem.onPress += &openOpenDialog;
		MenuItem recent = addWithEvent( "Open Recent" );
		Menu recentItems = new Menu;
		recent.submenu = recentItems;
		recentItems.appendItem( new MenuItem( "Item 1" ) );
		recentItems.appendItem( new MenuItem( "Item 2" ) );
		recentItems.appendItem( new MenuItem( "Item 3" ) );
		fileMenu.appendItem( MenuItem.separatorItem );
		addWithEvent( "Close", "w" );
		auto saveItem = addWithEvent( "Save", "s" );
		saveItem.onPress += &openSaveDialog;
		auto saveAsItem = addWithEvent( "Save As...", "s" );
		saveAsItem.addModifier( ModifierKey.Shift );
		
		mainWindow.menubar = menubar;
		
		mainWindow.onClose += &onWindowCloses;
		
		mainWindow.show( );
	}
	
	void menuItemPressed( Event e ) {
		MenuItem menuItem = cast(MenuItem)e.target;
		assert( menuItem !is null );
		
		version (Tango) {
			Stdout.formatln( "Action on menu item: {}", menuItem.title.dString );
		}
	}
	
	void openOpenDialog( Event e ) {
		version (Tango) {
			Stdout.formatln( "Opening open dialog..." );
		}
		
		FileOpenChooser chooser = new FileOpenChooser;
		
		chooser.onCompleted += &openDialogCompleted;
		chooser.allowsMultipleSelection = true;
		chooser.allowedFileTypes = [ "txt", "doc", "c", "d" ];
		
		chooser.beginModal( mainWindow );
	}
	
	void openDialogCompleted( Event e ) {
		FileOpenChooser chooser = cast(FileOpenChooser)e.target;
		
		version (Tango) {
			if ( chooser.fileWasChosen ) {
				Stdout.formatln( "Open dialog complete, user selected: {}", chooser.chosenPaths );
			} else {
				Stdout.formatln( "User cancelled open: {}", chooser );
			}
		}
	}
	
	void openSaveDialog( Event e ) {
		version (Tango) {
			Stdout.formatln( "Opening save dialog..." );
		}
		
		FileSaveChooser chooser = new FileSaveChooser;
		
		chooser.onCompleted += &saveDialogCompleted;
		chooser.allowedFileTypes = [ "chisel" ];
		
		chooser.beginModal( mainWindow );
	}
	
	void saveDialogCompleted( Event e ) {
		FileSaveChooser chooser = cast(FileSaveChooser)e.target;
		
		version (Tango) {
			if ( chooser.fileWasChosen ) {
				Stdout.formatln( "Save dialog complete, user selected: {}", chooser.chosenPath );
			} else {
				Stdout.formatln( "User cancelled save: {}", chooser );
			}
		}
	}
	
	void printAction( unicode description )( ) {
		version (Tango) {
			Stdout.formatln( "Action: {}", description );
		}
	}
	
	void onWindowCloses( ) {
		stop( );
	}
}

int main( char[][] args ) {
	auto app = new DialogsApp( );
	app.run( );
	
	return 0;
}

