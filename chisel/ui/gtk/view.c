#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>

native_handle _chisel_native_view_create( ) {
	return NULL;
}

void _chisel_native_view_add_subview( native_handle native, native_handle subview ) {
	
}

void _chisel_native_view_set_frame( native_handle native, Rect frame ) {
	
}

Rect _chisel_native_view_get_frame( native_handle native ) {
	Rect r;
	
	return r;
}

void _chisel_native_view_invalidate_rect( native_handle native, Rect rect ) {
	
}

native_handle _chisel_native_view_get_subviews( native_handle native ) {
	return NULL;
}
