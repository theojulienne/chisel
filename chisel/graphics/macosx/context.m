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

void _chisel_native_graphicscontext_begin_path( native_handle native ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextBeginPath( context );
}

void _chisel_native_graphicscontext_move_to_point( native_handle native, CLFloat x, CLFloat y ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextMoveToPoint( context, x, y );
}

void _chisel_native_graphicscontext_line_to_point( native_handle native, CLFloat x, CLFloat y ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextAddLineToPoint( context, x, y );
}

void _chisel_native_graphicscontext_curve_to_point( native_handle native, CLFloat cp1X, CLFloat cp1Y, CLFloat cp2X, CLFloat cp2Y, CLFloat endX, CLFloat endY ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextAddCurveToPoint( context, cp1X, cp1Y, cp2X, cp2Y, endX, endY );
}

void _chisel_native_graphicscontext_close_path( native_handle native ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextClosePath( context );
}

void _chisel_native_graphicscontext_stroke_path( native_handle native ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextStrokePath( context );
}

void _chisel_native_graphicscontext_fill_path( native_handle native ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextFillPath( context );
}

void _chisel_native_graphicscontext_translate( native_handle native, CLFloat x, CLFloat y ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextTranslateCTM( context, x, y );
}

void _chisel_native_graphicscontext_scale( native_handle native, CLFloat x, CLFloat y ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextScaleCTM( context, x, y );
}

void _chisel_native_graphicscontext_set_fill_color( native_handle native, CLFloat r, CLFloat g, CLFloat b, CLFloat a ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextSetRGBFillColor( context, r, g, b, a );
}

void _chisel_native_graphicscontext_set_stroke_color( native_handle native, CLFloat r, CLFloat g, CLFloat b, CLFloat a ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextSetRGBStrokeColor( context, r, g, b, a );
}

void _chisel_native_graphicscontext_clear_rect( native_handle native, Rect rect ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextClearRect( context, RectToCGRect( rect ) );
}

void _chisel_native_graphicscontext_fill_rect( native_handle native, Rect rect ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextFillRect( context, RectToCGRect( rect ) );
}

void _chisel_native_graphicscontext_stroke_rect( native_handle native, Rect rect ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextStrokeRect( context, RectToCGRect( rect ) );
}

void _chisel_native_graphicscontext_set_line_cap( native_handle native, int cap ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGLineCap lookup[] = {
		kCGLineCapButt,
		kCGLineCapRound,
		kCGLineCapSquare
	};
	
	CGContextSetLineCap( context, lookup[cap] );
}

void _chisel_native_graphicscontext_set_line_join( native_handle native, int join ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGLineJoin lookup[] = {
		kCGLineJoinMiter,
		kCGLineJoinRound,
		kCGLineJoinBevel
	};
	
	CGContextSetLineJoin( context, lookup[join] );
}

void _chisel_native_graphicscontext_set_blend_mode( native_handle native, int mode ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGBlendMode lookup[] = {
		kCGBlendModeNormal, // Normal=0,
		kCGBlendModeMultiply, // Multiply,
		kCGBlendModeScreen, // Screen,
		kCGBlendModeOverlay, // Overlay,
		kCGBlendModeDarken, // Darken,
		kCGBlendModeLighten, // Lighten,
		kCGBlendModeColorDodge, // ColorDodge,
		kCGBlendModeColorBurn, // ColorBurn,
		kCGBlendModeSoftLight, // SoftLight,
		kCGBlendModeHardLight, // HardLight,
		kCGBlendModeDifference, // Difference,
		kCGBlendModeExclusion, // Exclusion,
		kCGBlendModeHue, // Hue,
		kCGBlendModeSaturation, // Saturation,
		kCGBlendModeColor, // Color,
		kCGBlendModeLuminosity, // Luminosity,

		kCGBlendModeClear, // Clear,
		kCGBlendModeCopy, // Copy,

		kCGBlendModeSourceIn, // SourceIn,
		kCGBlendModeSourceOut, // SourceOut,
		kCGBlendModeSourceAtop, // SourceAtop,

		kCGBlendModeDestinationOver, // DestinationOver,
		kCGBlendModeDestinationIn, // DestinationIn,
		kCGBlendModeDestinationOut, // DestinationOut,
		kCGBlendModeDestinationAtop, // DestinationAtop,

		kCGBlendModeXOR, // XOR,
		kCGBlendModePlusDarker, // PlusDarker,
		kCGBlendModePlusLighter // PlusLighter,
	};
	
	CGContextSetBlendMode( context, lookup[mode] );
}

void _chisel_native_graphicscontext_set_line_width( native_handle native, CLFloat width ) {
	NSGraphicsContext *gc = (NSGraphicsContext *)native;
	CGContextRef context = (CGContextRef)[gc graphicsPort];
	
	CGContextSetLineWidth( context, width );
}

