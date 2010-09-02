#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-graphics.h>
#include <chisel-native-font.h>
#include <chisel-native-textframe.h>
#include <chisel-native-text-helpers.h>

native_handle _chisel_native_textframe_draw( native_handle ntextframe, native_handle ncontext ) {
	CTFrameRef frame = (CTFrameRef)ntextframe;
	NSGraphicsContext *gContext = (NSGraphicsContext *)ncontext;
	CGContextRef context = [gContext graphicsPort];
	
	CGContextSaveGState( context );
	
	CGAffineTransform t = CGAffineTransformScale( CGAffineTransformIdentity, 1, -1 );
	CGContextSetTextMatrix( context, t );
	
	//CGContextSetTextPosition( context, point.x, point.y );
	
	//CGContextSetTextMatrix( context, CGAffineTransformIdentity );
	CGPathRef path = CTFrameGetPath( frame );
	CGRect rect = CGPathGetBoundingBox( path );
	
	CFArrayRef lines = CTFrameGetLines( frame );
	int numLines = CFArrayGetCount( lines );
	
	CFRange lineRange = CFRangeMake( 0, 0 );
	CGPoint points[numLines];
	CTFrameGetLineOrigins( frame, lineRange, points );
	
	CGFloat lineHeight = 0;
	
	if ( numLines > 0 ) {
		CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex( lines, 0 );
	
		CTLineGetTypographicBounds( line, &lineHeight, NULL, NULL );
	}
	
	int i;
	for ( i = 0; i < numLines; i++ ) {
		CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex( lines, i );
		
		float x = points[i].x;
		float y = points[0].y - points[i].y;
		
		CGContextSetTextPosition( context, rect.origin.x + x, rect.origin.y + y + lineHeight );
		CTLineDraw( line, context );
	}
	//CTFrameDraw( frame, context );
	
	CFRelease( lines );
	
	CGContextRestoreGState( context );
}
