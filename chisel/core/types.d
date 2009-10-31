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
}
