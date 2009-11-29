#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-filesavechooser.h>

native_handle _chisel_native_filesavechooser_create( ) {
	GtkWidget *dialog;
	
	dialog = gtk_file_chooser_dialog_new( "Save File", NULL,
		GTK_FILE_CHOOSER_ACTION_SAVE,
		GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
		GTK_STOCK_SAVE, GTK_RESPONSE_ACCEPT,
		NULL
	);
	
	return dialog;
}

void _chisel_native_filesavechooser_set_show_hidden( native_handle chooser, int flag ) {
	gtk_file_chooser_set_show_hidden( GTK_FILE_CHOOSER(chooser), flag );
}

int _chisel_native_filesavechooser_get_show_hidden( native_handle chooser ) {
	return gtk_file_chooser_get_show_hidden( GTK_FILE_CHOOSER(chooser) );
}

void _chisel_native_filesavechooser_set_can_mkdir( native_handle chooser, int flag ) {
	gtk_file_chooser_set_create_folders( GTK_FILE_CHOOSER(chooser), flag );
}

int _chisel_native_filesavechooser_get_can_mkdir( native_handle chooser ) {
	return gtk_file_chooser_get_create_folders( GTK_FILE_CHOOSER(chooser) );
}

void _chisel_native_filesavechooser_set_allowed_file_types( native_handle chooser, native_handle types ) {
	
}

native_handle _chisel_native_filesavechooser_get_allowed_file_types( native_handle chooser ) {
	return NULL;
}

void _chisel_native_filesavechooser_begin_modal( native_handle chooser, native_handle nwindow ) {
	GtkWidget *dialog = GTK_WIDGET(chooser);
	GtkWidget *window = GTK_WIDGET(nwindow);
	
	assert( dialog != NULL );
	
	int response = gtk_dialog_run( GTK_DIALOG(dialog) );
	
	_chisel_native_filesavechooser_completed_callback( chooser, (response == GTK_RESPONSE_ACCEPT) );
	
	gtk_widget_hide( dialog );
}

native_handle _chisel_native_filesavechooser_get_path( native_handle chooser ) {
	char *filename = gtk_file_chooser_get_filename( GTK_FILE_CHOOSER(chooser) );
	native_handle str = _chisel_native_string_create_with_utf8_bytes( filename, strlen(filename) );
	
	g_free( filename );
	
	return (native_handle)str;
}

