#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <glib.h>
#include <glib-object.h>

#include <chisel-native.h>
#include <chisel-native-string.h>

native_handle _chisel_native_string_create_with_utf8_bytes( char* buf, int bytes ) {
	GString *str = g_string_new_len( buf, bytes );
	
	gpointer obj = g_object_new( G_TYPE_OBJECT, NULL );
	g_object_set_data( G_OBJECT(obj), "gstring", str );

	return (native_handle)obj;
}

int _chisel_native_string_unicode_length( native_handle native ) {
	gpointer obj = (gpointer )native;
	GString *str = (GString *)g_object_get_data( G_OBJECT(obj), "gstring" );
	
	return g_utf8_strlen( str->str, -1 );
}

int _chisel_native_string_utf8_bytes( native_handle native ) {
	gpointer obj = (gpointer )native;
	GString *str = (GString *)g_object_get_data( G_OBJECT(obj), "gstring" );
	
	return str->len;
}

void _chisel_native_string_get_utf8( native_handle native, char* buf, int maxBytes ) {
	gpointer obj = (gpointer )native;
	GString *str = (GString *)g_object_get_data( G_OBJECT(obj), "gstring" );
	
	assert( maxBytes > str->len );
	
	strncpy( buf, str->str, maxBytes );
	buf[maxBytes-1] = 0;
}

// compares 2 native strings for equality
int _chisel_native_string_equals( native_handle lhs, native_handle rhs ) {
	gpointer objLHS = (gpointer )lhs;
	GString *strLHS = (GString *)g_object_get_data( G_OBJECT(objLHS), "gstring" );
	gpointer objRHS = (gpointer )rhs;
	GString *strRHS = (GString *)g_object_get_data( G_OBJECT(objRHS), "gstring" );
	
	return g_utf8_collate( strLHS->str, strRHS->str ) == 0;
}

// compares 2 native strings, returning the D-style opCmp order
// (lhs < rhs) --> lhs.opCmd(rhs) < 0
// therefore: lhs < rhs, return < 0
// therefore: lhs ==rhs, return = 0
// therefore: lhs > rhs, return > 0
int _chisel_native_string_compare( native_handle lhs, native_handle rhs ) {
	gpointer objLHS = (gpointer )lhs;
	GString *strLHS = (GString *)g_object_get_data( G_OBJECT(objLHS), "gstring" );
	gpointer objRHS = (gpointer )rhs;
	GString *strRHS = (GString *)g_object_get_data( G_OBJECT(objRHS), "gstring" );
	
	return g_utf8_collate( strLHS->str, strRHS->str );
}
