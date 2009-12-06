module chisel.core.application;

import chisel.core.native;
import chisel.core.string;
import chisel.core.utf;
import chisel.core.cobject;

extern (C) {
	void _chisel_native_application_init( );
	void _chisel_native_application_run( );
	void _chisel_native_application_stop( );
	
	void _chisel_native_application_name_updated( );
	
	void _chisel_native_application_set_use_idle_task( int );
	
	void _chisel_native_application_idle_task_callback( ) {
		Application app = Application.sharedApplication;
		
		app.idleTask( );
	}
	
	native_handle _chisel_native_application_name_callback( ) {
		Application app = Application.sharedApplication;
		
		if ( app._applicationName is null ) {
			return null;
		}
		
		return app._applicationName.native;
	}
	
	void _chisel_native_application_quit_callback( ) {
		Application app = Application.sharedApplication;
		
		app.quit( );
	}
}

class Application : CObject {
	static Application _sharedApplication = null;
	
	static Application sharedApplication( ) {
		if ( _sharedApplication is null ) {
			_sharedApplication = new Application;
		}
		
		return _sharedApplication;
	}
	
	String _applicationName = null;
	
	this( unicode appName ) {
		this( );
		applicationName = appName;
	}
	
	this( String appName ) {
		this( );
		applicationName = appName;
	}
	
	this( ) {
		_chisel_native_application_init( );
		
		super( );
		
		assert( _sharedApplication is null );
		
		_sharedApplication = this;
	}
	
	void run( ) {
		_chisel_native_application_run( );
	}
	
	void stop( ) {
		_chisel_native_application_stop( );
	}
	
	bool _useIdleTask = false;
	
	void useIdleTask( bool state ) {
		_useIdleTask = state;
		_chisel_native_application_set_use_idle_task( state ? 1 : 0 );
	}
	
	bool useIdleTask( ) {
		return _useIdleTask;
	}
	
	void idleTask( ) {
		
	}
	
	void applicationName( String name ) {
		_applicationName = name;
		_chisel_native_application_name_updated( );
	}
	
	void applicationName( unicode name ) {
		applicationName = String.fromUTF8( name );
	}
	
	String applicationName( ) {
		return _applicationName;
	}
	
	void quit( ) {
		stop( );
	}
}
