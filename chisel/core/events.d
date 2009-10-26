module chisel.core.events;

class Event {
	private bool _should_stop = false;
	
	void stop( ) {
		_should_stop = true;
	}
	
	bool stopped( ) {
		return _should_stop;
	}
}

struct EventManager {
	EventDelegate handlers[];
	
	void opAddAssign(T)( T handler ) {
		assert( handler !is null );
		handlers ~= EventDelegate( handler );
	}
	
	void call( ) {
		Event e = new Event;
		
		foreach_reverse ( handler; handlers ) {
			handler( e );
			
			if ( e.stopped ) {
				break;
			}
		}
	}
}

struct EventDelegate {
	enum DelegateType {
		Simple,
		Full,
	}
	
	void delegate() simpleDel;
	void delegate(Event e) fullDel;
	DelegateType t;
	
	static EventDelegate opCall( void delegate() del ) {
		EventDelegate dg;
		dg.t = DelegateType.Simple;
		dg.simpleDel = del;
		return dg;
	}
	
	static EventDelegate opCall( void delegate(Event e) del ) {
		EventDelegate dg;
		dg.t = DelegateType.Full;
		dg.fullDel = del;
		return dg;
	}
	
	void opCall( Event e ) {
		switch (t) {
			case DelegateType.Simple:
				simpleDel( );
				break;
			case DelegateType.Full:
				fullDel( e );
				break;
			default:
				assert( false );
		}
	}
}
