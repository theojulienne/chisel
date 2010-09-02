#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-graphics.h>
#include <chisel-native-font.h>
#include <chisel-native-formattedstring.h>
#include <chisel-native-text-helpers.h>

native_handle _chisel_native_formattedstring_create( native_handle text ) {
	NSString *nText = (NSString *)text;
	
	NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:nText];
	
	return (native_handle)result;
}

void _chisel_native_formattedstring_set_font( native_handle fs, CLRange range, native_handle font ) {
	NSMutableAttributedString *string = (NSMutableAttributedString *)fs;
	NSRange nRange = CLRangeToNSRange( range );
	CTFontRef nFont = (CTFontRef)font;
	
	[string addAttribute:(NSString *)kCTFontAttributeName value:(id)nFont range:nRange];
}

void _chisel_native_formattedstring_set_foreground_color( native_handle fs, CLRange range, native_handle color ) {
	NSMutableAttributedString *string = (NSMutableAttributedString *)fs;
	NSRange nRange = CLRangeToNSRange( range );
	CGColorRef nColor = (CTFontRef)color;
	
	[string addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)nColor range:nRange];
}

native_handle _chisel_native_formattedstring_get_string( native_handle fs ) {
	NSMutableAttributedString *maString = (NSMutableAttributedString *)fs;
	NSString *string = [maString string];
	
	return string;
}

void _chisel_native_formattedstring_draw( native_handle fs, native_handle ctx, CLPoint point ) {
	NSGraphicsContext *gContext = (NSGraphicsContext *)ctx;
	CGContextRef context = [gContext graphicsPort];
	CFAttributedStringRef attrString = (CFAttributedStringRef)fs;
	
	CTLineRef line = CTLineCreateWithAttributedString( attrString );
	CGAffineTransform t = CGAffineTransformScale( CGAffineTransformIdentity, 1, -1 );
	CGContextSetTextMatrix( context, t );
	CGContextSetTextPosition( context, point.x, point.y );
	CTLineDraw( line, context );
	
	CFRelease( line );
}
