module chisel.core.types;

alias int Index;

struct Range {
	Index location;
	Index length;
	
	static Range opCall( Index location, Index length ) {
		Range r;
		
		r.location = location;
		r.length = length;
		
		return r;
	}
	
	int opApply( int delegate(inout int) del ) {
		int ret;
		
		for ( int i = location; i < location+length; i++ ) {
			ret = del( i );
			if ( ret )
				break;
		}
		
		return ret;
	}
}
