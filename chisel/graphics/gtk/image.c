#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gdk-pixbuf/gdk-pixbuf.h>

#include <chisel-native.h>
#include <chisel-native-image.h>

native_handle _chisel_native_image_create_from_file( native_handle nFilename ) {
    GString *filename = (GString *)g_object_get_data( G_OBJECT(nFilename), "gstring" );
    
	return (native_handle)gdk_pixbuf_new_from_file( filename->str, NULL );
}
