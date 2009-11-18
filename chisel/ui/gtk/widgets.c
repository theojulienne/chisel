#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>

#include "compathacks.h"

static gboolean _chisel_gtk_resize_event( GtkWidget *widget, GdkEvent *event, gpointer native_data ) {
	int x = (int)g_object_get_data( G_OBJECT(widget), "chisel-allocation-x" );
	int y = (int)g_object_get_data( G_OBJECT(widget), "chisel-allocation-y" );
	int w = (int)g_object_get_data( G_OBJECT(widget), "chisel-allocation-w" );
	int h = (int)g_object_get_data( G_OBJECT(widget), "chisel-allocation-h" );
	
	GtkAllocation alloc;
	gtk_widget_get_allocation( GTK_WIDGET(widget), &alloc );
	
	if ( x != alloc.x || y != alloc.y || w != alloc.width || h != alloc.height ) {
		// changed!
		g_object_set_data( G_OBJECT(widget), "chisel-allocation-x", (void*)alloc.x );
		g_object_set_data( G_OBJECT(widget), "chisel-allocation-y", (void*)alloc.y );
		g_object_set_data( G_OBJECT(widget), "chisel-allocation-w", (void*)alloc.width );
		g_object_set_data( G_OBJECT(widget), "chisel-allocation-h", (void*)alloc.height );
		
		printf( "---\n" );
		printf( "frame changed! (%d-%d %d-%d %d-%d %d-%d)\n", x, alloc.x, y, alloc.y, w, alloc.width, h, alloc.height );
		_chisel_native_view_frame_changed_callback( widget );
	}
}

void _chisel_gtk_setup_events( GtkWidget *widget ) {
	g_signal_connect( G_OBJECT(widget), "size_allocate", G_CALLBACK(_chisel_gtk_resize_event), NULL );
	//g_signal_connect( G_OBJECT(widget), "configure_event", G_CALLBACK(_chisel_gtk_resize_event), NULL );
}
