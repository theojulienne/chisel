#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-string.h>

native_handle _chisel_native_string_create_with_utf8_bytes( char* buf, int bytes ) {
	NSString *str = [[NSString alloc] initWithBytes:buf length:bytes encoding:NSUTF8StringEncoding];
	
	//NSLog( @"string created: %p (retain count: %d)\n", str, [str retainCount] );
	
	return (native_handle)str;
}

int _chisel_native_string_unicode_length( native_handle native ) {
	NSString *str = (NSString *)native;
	
	return [str length];
}

int _chisel_native_string_utf8_bytes( native_handle native ) {
	NSString *str = (NSString *)native;
	
	return [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

void _chisel_native_string_get_utf8( native_handle native, char* buf, int maxBytes ) {
	NSString *str = (NSString *)native;
	
	[str getCString:buf maxLength:maxBytes encoding:NSUTF8StringEncoding];
}

// compares 2 native strings for equality
int _chisel_native_string_equals( native_handle lhs, native_handle rhs ) {
	NSString *nLHS = (NSString *)lhs;
	NSString *nRHS = (NSString *)rhs;
	
	return [nLHS isEqualToString:nRHS];
}

// compares 2 native strings, returning the D-style opCmp order
// (lhs < rhs) --> lhs.opCmd(rhs) < 0
// therefore: lhs < rhs, return < 0
// therefore: lhs ==rhs, return = 0
// therefore: lhs > rhs, return > 0
int _chisel_native_string_compare( native_handle lhs, native_handle rhs ) {
	NSString *nLHS = (NSString *)lhs;
	NSString *nRHS = (NSString *)rhs;
	
	// yay, Apple uses the same values in NSComparisonResult :D
	return (int)[nLHS compare:nRHS];
}
