using System;

using Chisel.Core;
using Chisel.UI;

public class Test : Application {
	private Window mainWindow;
	
	public Test( ) {
		//this.setApplicationName( "Test" );
		
		mainWindow = new Window( "☃ Test" );
		System.Console.WriteLine( "title={0}", mainWindow.title );
		
		mainWindow.show( );
	}
	
	public static void Main( ) {
		Test test = new Test( );
		System.Console.WriteLine( "Init'd app!" );
		test.run( );
	}
}
