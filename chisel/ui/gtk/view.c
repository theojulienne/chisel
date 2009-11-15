#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>

#define COORD_TO_PTR(x) ((void*)(int)(x))

void _chisel_native_helper_get_position( GObject *obj, int *x, int *y ) {
	*x = (int)g_object_get_data( obj, "chisel-position-x" );
	*y = (int)g_object_get_data( obj, "chisel-position-y" );
}

native_handle _chisel_native_view_create( ) {
	GtkWidget *widget = gtk_fixed_new( );
	
	g_object_set_data( G_OBJECT(widget), "chisel-content-view", widget );
	
	return (native_handle)widget;
}

void _chisel_native_view_add_subview( native_handle native, native_handle subview ) {
	GtkWidget *widget = GTK_WIDGET(native);
	GtkWidget *child = GTK_WIDGET(subview);
	
	GtkFixed *container = GTK_FIXED(g_object_get_data( G_OBJECT(widget), "chisel-content-view" ));
	
	int x, y;
	_chisel_native_helper_get_position( G_OBJECT(child), &x, &y );
	
	gtk_fixed_put( container, child, x, y );
}

void _chisel_native_view_set_frame( native_handle native, Rect frame ) {
	GtkWidget *widget = GTK_WIDGET(native);
	
	GtkRequisition req;
	
	req.width = frame.size.width;
	req.height = frame.size.height;
	
	gtk_widget_size_request( GTK_WIDGET(native), &req );
	
	g_object_set_data( G_OBJECT(widget), "chisel-position-x", COORD_TO_PTR(frame.origin.x) );
	g_object_set_data( G_OBJECT(widget), "chisel-position-y", COORD_TO_PTR(frame.origin.y) );
	
	GtkWidget *parent = gtk_widget_get_parent( widget );
	
	if ( parent != NULL ) {
		// reposition child in parent
		GtkFixed *fixed = GTK_FIXED(parent);
		
		gtk_fixed_move( fixed, widget, frame.origin.x, frame.origin.y );
	}
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
