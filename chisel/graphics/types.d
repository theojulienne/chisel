module chisel.graphics.types;

alias float CLFloat;

struct CLSize {
	CLFloat width;
	CLFloat height;
}

struct CLPoint {
	CLFloat x;
	CLFloat y;
}

struct CLRect {
	CLPoint origin;
	CLSize size;
	
	static CLRect opCall( CLFloat x, CLFloat y, CLFloat w, CLFloat h ) {
		CLRect r;
		
		r.origin.x = x;
		r.origin.y = y;
		r.size.width = w;
		r.size.height = h;
		
		return r;
	}
}
