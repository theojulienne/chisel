#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-progressbar.h>

native_handle _chisel_native_progressbar_create( ) {
	return NULL;
}

void _chisel_native_progressbar_set_minimum( native_handle native, CLFloat minValue ) {
	
}

void _chisel_native_progressbar_set_maximum( native_handle native, CLFloat maxValue ) {
	
}

void _chisel_native_progressbar_set_value( native_handle native, CLFloat value ) {
	
}

CLFloat _chisel_native_progressbar_get_value( native_handle native ) {
	return 0.0;
}

CLFloat _chisel_native_progressbar_get_thickness( native_handle native ) {
	return 0.0;
}

void _chisel_native_progressbar_set_indeterminate( native_handle native, int val ) {
	
}

int _chisel_native_progressbar_get_indeterminate( native_handle native ) {
	return 0;
}

void _chisel_native_progressbar_set_animating( native_handle native, int val ) {
	
}

int _chisel_native_progressbar_get_animating( native_handle native ) {
	return 0;
}
