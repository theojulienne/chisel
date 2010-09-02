#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-graphics.h>

native_handle _chisel_native_color_create_rgb( CLFloat r, CLFloat g, CLFloat b, CLFloat a ) {
	CGColorRef result = CGColorCreateGenericRGB( r, g, b, a );
	
	return (native_handle)result;
}

native_handle _chisel_native_color_create_cmyk( CLFloat c, CLFloat m, CLFloat y, CLFloat k, CLFloat a ) {
	CGColorRef result = CGColorCreateGenericCMYK( c, m, y, k, a );
	
	return (native_handle)result;
}
