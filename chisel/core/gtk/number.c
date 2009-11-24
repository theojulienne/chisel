#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <glib.h>

#include <chisel-native.h>
#include <chisel-native-number.h>

native_handle _chisel_native_number_create_with_double( double val ) {
	return NULL;
}

native_handle _chisel_native_number_create_with_int( int val ) {
	return NULL;
}

double _chisel_native_number_get_double( native_handle native ) {
	return 0.0;
}

int _chisel_native_number_get_int( native_handle native ) {
	return 0;
}

