#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <glib.h>
#include <glib-object.h>

#include <chisel-native.h>
#include <chisel-native-array.h>

native_handle _chisel_native_array_from_natives( native_handle *natives, int count ) {
	GList *list = NULL;
	int i;
	
	for ( i = 0; i < count; i++ ) {
		list = g_list_append( list, natives[i] );
	}
	
	gpointer obj = g_object_new( G_TYPE_OBJECT, NULL );
	g_object_set_data( G_OBJECT(obj), "glist", list );
	
	return obj;
}

uint _chisel_native_array_get_length( native_handle native ) {
	GList *list = (GList *)g_object_get_data( G_OBJECT(native), "glist" );
	
	return g_list_length( list );
}

native_handle _chisel_native_array_get_object( native_handle native, uint index ) {
	GList *list = (GList *)g_object_get_data( G_OBJECT(native), "glist" );

	return (native_handle)g_list_nth_data( list, index );
}
