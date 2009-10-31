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

native_handle _chisel_native_formattedstring_get_string( native_handle fs ) {
	NSMutableAttributedString *maString = (NSMutableAttributedString *)fs;
	NSString *string = [maString string];
	
	return string;
}
