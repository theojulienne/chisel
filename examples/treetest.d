module treetest;

version (Tango) {
	import tango.math.Math;
} else {
	import std.math;
}


import chisel.core.all;
import chisel.graphics.all;
import chisel.text.all;
import chisel.ui.all;

class TreeTestApp : Application {
	Window mainWindow;
	
	this( ) {
		mainWindow = new Window( "Tree Test" );
		mainWindow.setSize( 500, 500 );
		
		mainWindow.onClose += &stop;
		
		auto tv = new TreeView;
		
		tv.addTableColumn( new TableColumn( "Column A" ) );
		tv.addTableColumn( new TableColumn( "Column B" ) );
		tv.addTableColumn( new TableColumn( "Column C" ) );
		
		mainWindow.contentView = tv;
		
		mainWindow.show( );
	}
}

int main( char[][] args ) {
	auto app = new TreeTestApp( );
	app.run( );
	
	return 0;
}

