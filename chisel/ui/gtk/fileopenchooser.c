#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-fileopenchooser.h>
#include <chisel-native-string.h>


native_handle _chisel_native_fileopenchooser_create( ) {
	GtkWidget *dialog;
	
	dialog = gtk_file_chooser_dialog_new( "Open File", NULL,
		GTK_FILE_CHOOSER_ACTION_OPEN,
		GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
		GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
		NULL
	);
	
	return dialog;
}

void _chisel_native_fileopenchooser_set_show_hidden( native_handle chooser, int flag ) {
	gtk_file_chooser_set_show_hidden( GTK_FILE_CHOOSER(chooser), flag );
}

int _chisel_native_fileopenchooser_get_show_hidden( native_handle chooser ) {
	return gtk_file_chooser_get_show_hidden( GTK_FILE_CHOOSER(chooser) );
}

void _chisel_native_fileopenchooser_set_can_mkdir( native_handle chooser, int flag ) {
	gtk_file_chooser_set_create_folders( GTK_FILE_CHOOSER(chooser), flag );
}

int _chisel_native_fileopenchooser_get_can_mkdir( native_handle chooser ) {
	return gtk_file_chooser_get_create_folders( GTK_FILE_CHOOSER(chooser) );
}

void _chisel_native_fileopenchooser_set_allows_multiple( native_handle chooser, int flag ) {
	gtk_file_chooser_set_select_multiple( GTK_FILE_CHOOSER(chooser), flag );
}

int _chisel_native_fileopenchooser_get_allows_multiple( native_handle chooser ) {
	return gtk_file_chooser_get_select_multiple( GTK_FILE_CHOOSER(chooser) );
}

void _chisel_native_fileopenchooser_set_can_choose_files( native_handle chooser, int flag ) {
	gtk_file_chooser_set_action( GTK_FILE_CHOOSER(chooser), flag ? GTK_FILE_CHOOSER_ACTION_OPEN : GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER );
}

int _chisel_native_fileopenchooser_get_can_choose_files( native_handle chooser ) {
	return gtk_file_chooser_get_action( GTK_FILE_CHOOSER(chooser) ) == GTK_FILE_CHOOSER_ACTION_OPEN;
}

void _chisel_native_fileopenchooser_set_can_choose_directories( native_handle chooser, int flag ) {
	gtk_file_chooser_set_action( GTK_FILE_CHOOSER(chooser), flag ? GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER : GTK_FILE_CHOOSER_ACTION_OPEN );
}

int _chisel_native_fileopenchooser_get_can_choose_directories( native_handle chooser ) {
	return gtk_file_chooser_get_action( GTK_FILE_CHOOSER(chooser) ) == GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER;
}

void _chisel_native_fileopenchooser_set_allowed_file_types( native_handle chooser, native_handle types ) {
	
}

native_handle _chisel_native_fileopenchooser_get_allowed_file_types( native_handle chooser ) {
	return NULL;
}

static void response_cb( GtkDialog *dialog, gint response_id, gpointer user_data ) {
	gtk_widget_hide( GTK_WIDGET(dialog) );

	_chisel_native_fileopenchooser_completed_callback( dialog, (response_id == GTK_RESPONSE_ACCEPT) );
}

void _chisel_native_fileopenchooser_begin_modal( native_handle chooser, native_handle nwindow ) {
	GtkWidget *dialog = GTK_WIDGET(chooser);
	GtkWidget *window = GTK_WIDGET(nwindow);
	
	assert( dialog != NULL );
	
	g_signal_connect( dialog, "response", G_CALLBACK(response_cb), NULL );
	
	gtk_widget_show_all( dialog );
	
	/*int response = gtk_dialog_run( GTK_DIALOG(dialog) );
	
	gtk_widget_hide( dialog );
	
	_chisel_native_fileopenchooser_completed_callback( chooser, (response == GTK_RESPONSE_ACCEPT) );
	*/
}

native_handle _chisel_native_fileopenchooser_get_paths( native_handle chooser ) {
	GSList *filenamesRaw = gtk_file_chooser_get_filenames( GTK_FILE_CHOOSER(chooser) );
	GList *filenames = NULL;
	
	GSList *node;
	for ( node = filenamesRaw; node != NULL; node = g_slist_next(node) ) {
		char* filename = (char *)node->data;
		native_handle str = _chisel_native_string_create_with_utf8_bytes( filename, strlen(filename) );
		
		filenames = g_list_append( filenames, str );
		
		g_free( filename );
	}
	
	g_slist_free( filenamesRaw );
	
	gpointer obj = g_object_new( G_TYPE_OBJECT, NULL );
	g_object_set_data( G_OBJECT(obj), "glist", filenames );
	
	return (native_handle)obj;
}

