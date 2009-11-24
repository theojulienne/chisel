#include <Cocoa/Cocoa.h>

#include <chisel-native-graphics.h>

Rect NSRectToRect( NSRect inRect ) {
	Rect rect;
	
	rect.origin.x = inRect.origin.x;
	rect.origin.y = inRect.origin.y;
	rect.size.width = inRect.size.width;
	rect.size.height = inRect.size.height;
	
	return rect;
}

NSRect RectToNSRect( Rect inRect ) {
	NSRect rect;
	
	rect.origin.x = inRect.origin.x;
	rect.origin.y = inRect.origin.y;
	rect.size.width = inRect.size.width;
	rect.size.height = inRect.size.height;
	
	return rect;
}

Rect CGRectToRect( CGRect inRect ) {
	Rect rect;
	
	rect.origin.x = inRect.origin.x;
	rect.origin.y = inRect.origin.y;
	rect.size.width = inRect.size.width;
	rect.size.height = inRect.size.height;
	
	return rect;
}

CGRect RectToCGRect( Rect inRect ) {
	CGRect rect;
	
	rect.origin.x = inRect.origin.x;
	rect.origin.y = inRect.origin.y;
	rect.size.width = inRect.size.width;
	rect.size.height = inRect.size.height;
	
	return rect;
}

