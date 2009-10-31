#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-graphics.h>
#include <chisel-native-font.h>

native_handle _chisel_native_font_create_with_name( native_handle name, CLFloat size ) {
	CFStringRef nName = (native_handle)name;
	
	native_handle result = (native_handle)CTFontCreateWithName( nName, size, NULL );
	
	return result;
}

CLFloat _chisel_native_font_get_size( native_handle native ) {
	CTFontRef font = (CTFontRef)native;
	
	return CTFontGetSize( font );
}

native_handle _chisel_native_font_get_family_name( native_handle native ) {
	CTFontRef font = (CTFontRef)native;
	
	return (native_handle)CTFontCopyFamilyName( font );
}

native_handle _chisel_native_font_get_full_name( native_handle native ) {
	CTFontRef font = (CTFontRef)native;
	
	return (native_handle)CTFontCopyFullName( font );
}

