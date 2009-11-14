module chisel.core.application;

import chisel.core.cobject;

extern (C) {
	void _chisel_native_application_init( );
	void _chisel_native_application_run( );
	void _chisel_native_application_stop( );
	
	void _chisel_native_application_set_use_idle_task( int );
	
	void _chisel_native_application_idle_task_callback( ) {
		Application app = Application.sharedApplication;
		
		app.idleTask( );
	}
}

static this( ) {
	_chisel_native_application_init( );
}

class Application : CObject {
	static Application _sharedApplication = null;
	
	static Application sharedApplication( ) {
		if ( _sharedApplication is null ) {
			_sharedApplication = new Application;
		}
		
		return _sharedApplication;
	}
	
	this( ) {
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
}
