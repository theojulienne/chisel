module chisel.core.types;

alias long CLIndex;

struct CLRange {
	CLIndex location;
	CLIndex length;
	
	static CLRange opCall( CLIndex location, CLIndex length ) {
		CLRange r;
		
		r.location = location;
		r.length = length;
		
		return r;
	}
}
