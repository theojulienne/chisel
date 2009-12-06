#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-application.h>
#include <chisel-native-bridge.h>

void _chisel_native_handle_destroy( native_handle native ) {
	
}

void _chisel_native_application_init( ) {
	gtk_init( NULL, NULL );
}

void _chisel_native_application_run( ) {
	gtk_main( );
}

void _chisel_native_application_stop( ) {
	gtk_main_quit( );
}

gboolean _chisel_native_idle_task( gpointer data ) {
	_chisel_native_application_idle_task_callback( );
	
	return TRUE;
}

void _chisel_native_application_set_use_idle_task( int status ) {
	static gboolean currentStatus = FALSE;
	
	if ( status && !currentStatus ) {
		g_idle_add( _chisel_native_idle_task, _chisel_native_idle_task );
	} else if ( !status && currentStatus ) {
		g_idle_remove_by_data( _chisel_native_idle_task );
	}
	
	currentStatus = status;
}

void _chisel_native_handle_bridge_registered( native_handle native ) {
	
}

void _chisel_native_handle_bridge_deregistered( native_handle native ) {
	
}

void _chisel_native_application_name_updated( ) {

}

