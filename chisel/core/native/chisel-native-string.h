// note "bytes" does not include the terminating NULL character
native_handle _chisel_native_string_create_with_utf8_bytes( char* buf, int bytes );

// returns the number of unicode characters
// (note this may not be the same as the byte length)
int _chisel_native_string_unicode_length( native_handle );

// returns the number of bytes required to represent this string in utf8
// this does NOT include the NULL terminating character
int _chisel_native_string_utf8_bytes( native_handle );

// fills buf with a NULL terminated utf8 string, using no more than maxBytes
// bytes.
void _chisel_native_string_get_utf8( native_handle, char* buf, int maxBytes );

// compares 2 native strings for equality
int _chisel_native_string_equals( native_handle lhs, native_handle rhs );

// compares 2 native strings, returning the D-style opCmp order
// (lhs < rhs) --> lhs.opCmd(rhs) < 0
int _chisel_native_string_compare( native_handle lhs, native_handle rhs );
