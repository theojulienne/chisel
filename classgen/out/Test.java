import chisel.core.*;
import chisel.ui.*;

public class Test extends Application {
	private Window mainWindow;
	
	public Test( ) {
		//this.setApplicationName( "Test" );
		
		mainWindow = new Window( );
		
		mainWindow.show( );
	}
	
	public static void main( String[] args ) {
		Test test = new Test( );
		System.out.println( "Init'd app!" );
		test.run( );
	}
}
