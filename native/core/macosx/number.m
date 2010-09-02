#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-number.h>

native_handle _chisel_native_number_create_with_double( double val ) {
	return (native_handle)[NSNumber numberWithDouble:val];
}

native_handle _chisel_native_number_create_with_int( int val ) {
	return (native_handle)[NSNumber numberWithInteger:val];
}

double _chisel_native_number_get_double( native_handle native ) {
	NSNumber *num = (NSNumber *)native;
	
	return [num doubleValue];
}

int _chisel_native_number_get_int( native_handle native ) {
	NSNumber *num = (NSNumber *)native;
	
	return [num intValue];
}
