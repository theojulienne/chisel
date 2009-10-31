#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-graphics.h>
#include <chisel-native-context.h>

void _chisel_native_graphicscontext_save_graphics_state( native_handle native ) {
	NSGraphicsContext *context = (NSGraphicsContext *)native;
	[context saveGraphicsState];
}

void _chisel_native_graphicscontext_restore_graphics_state( native_handle native ) {
	NSGraphicsContext *context = (NSGraphicsContext *)native;
	[context restoreGraphicsState];
}

/*
void _chisel_native_graphicscontext_set_current_context( NSGraphicsContext *context ) {
	[NSGraphicsContext setCurrentContext:context];
}
*/

native_handle _chisel_native_graphicscontext_get_current_context( ) {
	return (native_handle)[NSGraphicsContext currentContext];
}

void _chisel_native_graphicscontext_draw_formattedstring( native_handle native, native_handle fs, CLPoint point ) {
	NSGraphicsContext *gContext = (NSGraphicsContext *)native;
	CGContextRef context = [gContext graphicsPort];
	CFAttributedStringRef attrString = (CFAttributedStringRef)fs;
	
	CTLineRef line = CTLineCreateWithAttributedString( attrString );
	CGAffineTransform t = CGAffineTransformScale( CGAffineTransformIdentity, 1, -1 );
	CGContextSetTextMatrix( context, t );
	CGContextSetTextPosition( context, point.x, point.y );
	CTLineDraw( line, context );
	
	CFRelease( line );
}

/*
void _chisel_native_graphicscontext_draw_text( native_handle native, char *utf8 ) {
	NSGraphicsContext *context = (NSGraphicsContext *)native;
	//CGContextRef cg = (CGContextRef)[context graphicsPort];
	
	NSString *str = [[NSString alloc] initWithUTF8String:utf8];
	NSFont* font = [NSFont fontWithName:@"Helvetica" size:64.0];
	
	NSDictionary *attr = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
	
	NSPoint pt = NSMakePoint( 0, 0 );
	
	[font setInContext: context];
	[str drawAtPoint:pt withAttributes:attr];
	//[str drawInRect:CGRectMake(20, 20, 40, 40) withFont:font];
	
	[attr release];
	[str release];
	[font release];
}
*/