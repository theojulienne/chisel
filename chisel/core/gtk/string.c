#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-string.h>

native_handle _chisel_native_string_create_with_utf8_bytes( char* buf, int bytes ) {
	return NULL;
}

int _chisel_native_string_unicode_length( native_handle native ) {
	return 0;
}

int _chisel_native_string_utf8_bytes( native_handle native ) {
	return 0;
}

void _chisel_native_string_get_utf8( native_handle native, char* buf, int maxBytes ) {
	
}

// compares 2 native strings for equality
int _chisel_native_string_equals( native_handle lhs, native_handle rhs ) {
	return 0;
}

// compares 2 native strings, returning the D-style opCmp order
// (lhs < rhs) --> lhs.opCmd(rhs) < 0
// therefore: lhs < rhs, return < 0
// therefore: lhs ==rhs, return = 0
// therefore: lhs > rhs, return > 0
int _chisel_native_string_compare( native_handle lhs, native_handle rhs ) {
	return 0;
}
