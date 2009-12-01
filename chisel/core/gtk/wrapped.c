#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <glib.h>
#include <glib-object.h>

#include <chisel-native.h>
#include <chisel-native-wrapped.h>

native_handle _chisel_native_create_wrapped_object( object_handle handle ) {
	native_handle obj = g_object_new( G_TYPE_OBJECT, NULL );
	g_object_set_data( G_OBJECT(obj), "chisel-object", handle );
	return obj;
}

