#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-filesavechooser.h>

native_handle _chisel_native_filesavechooser_create( ) {
	return NULL;
}

void _chisel_native_filesavechooser_set_show_hidden( native_handle chooser, int flag ) {
	
}

int _chisel_native_filesavechooser_get_show_hidden( native_handle chooser ) {
	return 0;
}

void _chisel_native_filesavechooser_set_can_mkdir( native_handle chooser, int flag ) {
	
}

int _chisel_native_filesavechooser_get_can_mkdir( native_handle chooser ) {
	return 0;
}

void _chisel_native_filesavechooser_set_allowed_file_types( native_handle chooser, native_handle types ) {
	
}

native_handle _chisel_native_filesavechooser_get_allowed_file_types( native_handle chooser ) {
	return NULL;
}

void _chisel_native_filesavechooser_begin_modal( native_handle chooser, native_handle nwindow ) {
	
}

native_handle _chisel_native_filesavechooser_get_path( native_handle chooser ) {
	return NULL;
}

