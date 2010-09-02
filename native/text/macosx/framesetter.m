#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-graphics.h>
#include <chisel-native-font.h>
#include <chisel-native-framesetter.h>
#include <chisel-native-text-helpers.h>

native_handle _chisel_native_framesetter_create( native_handle nformattedString ) {
	CFAttributedStringRef formattedString = (CFAttributedStringRef)nformattedString;
	
	CTFramesetterRef result = CTFramesetterCreateWithAttributedString( formattedString );
	
	return (native_handle)result;
}

native_handle _chisel_native_framesetter_create_textframe_from_rect( native_handle nframesetter, CLRange range, CLRect rect ) {
	CTFramesetterRef framesetter = (CTFramesetterRef)nframesetter;
	CFRange nRange = CLRangeToCFRange( range );
	
	// create the bounds for the text flow
	CGMutablePathRef path = CGPathCreateMutable( );
	CGRect bounds = RectToCGRect( rect );
	CGPathAddRect( path, NULL, bounds );
	
	CTFrameRef frame = CTFramesetterCreateFrame( framesetter, nRange, path, NULL );
	
	return (native_handle)frame;
}