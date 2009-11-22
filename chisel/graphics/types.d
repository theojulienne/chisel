module chisel.graphics.types;

alias float CLFloat;

struct Size {
	CLFloat width;
	CLFloat height;
}

struct Point {
	CLFloat x;
	CLFloat y;
}

struct Rect {
	Point origin;
	Size size;
	
	static Rect opCall( CLFloat x, CLFloat y, CLFloat w, CLFloat h ) {
		Rect r;
		
		r.origin.x = x;
		r.origin.y = y;
		r.size.width = w;
		r.size.height = h;
		
		return r;
	}
}

struct Color {
	CLFloat red;
	CLFloat green;
	CLFloat blue;
	CLFloat alpha;
	
	static Color opCall( CLFloat red, CLFloat green, CLFloat blue, CLFloat alpha ) {
		Color c;
		
		c.red = red;
		c.green = green;
		c.blue = blue;
		c.alpha = alpha;
		
		return c;
	}
	
	static Color opCall( CLFloat red, CLFloat green, CLFloat blue ) {
		return Color( red, green, blue, 1.0 );
	}
}
