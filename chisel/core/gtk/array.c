#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <glib.h>

#include <chisel-native.h>
#include <chisel-native-array.h>

native_handle _chisel_native_array_from_natives( native_handle *natives, int count ) {
	return NULL;
}

uint _chisel_native_array_get_length( native_handle native ) {
	return g_list_length( (GList *)(native) );
}

native_handle _chisel_native_array_get_object( native_handle native, uint index ) {
	return (native_handle)g_list_nth_data( (GList *)(native), index );
}
