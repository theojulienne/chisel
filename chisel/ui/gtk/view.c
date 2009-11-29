#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>

#include "compathacks.h"

#include "widgets.h"

void _chisel_native_helper_get_position( GObject *obj, int *x, int *y ) {
	*x = (int)g_object_get_data( obj, "chisel-position-x" );
	*y = (int)g_object_get_data( obj, "chisel-position-y" );
}

native_handle _chisel_native_view_create( ) {
	GtkWidget *widget = gtk_layout_new( NULL, NULL );
	
	g_object_set_data( G_OBJECT(widget), "chisel-content-view", widget );
	
	_chisel_gtk_setup_events( widget );
	
	return (native_handle)widget;
}

void _chisel_native_view_add_subview( native_handle native, native_handle subview ) {
	GtkWidget *widget = GTK_WIDGET(native);
	GtkWidget *child = GTK_WIDGET(subview);
	
	GtkWidget *container = widget;
	
	GtkWidget *ref = g_object_get_data( G_OBJECT(widget), "chisel-content-view" );
	if ( ref != NULL ) {
		container = ref;
	}
	
	int x, y;
	_chisel_native_helper_get_position( G_OBJECT(child), &x, &y );
	
	if ( GTK_IS_LAYOUT(container) ) {
		gtk_layout_put( GTK_LAYOUT(container), child, x, y );
	} else if ( GTK_IS_CONTAINER(container) ) {
		gtk_container_add( GTK_CONTAINER(container), child );
	} else {
		printf( "could not add subview to container at %p\n", container );
	}
	
	gtk_widget_show( GTK_WIDGET(child) );
}

void _chisel_native_view_set_frame( native_handle native, Rect frame ) {
	GtkWidget *widget = GTK_WIDGET(native);
	
	int width, height;
	
	width = frame.size.width;
	height = frame.size.height;
	
	GtkAllocation allocation;
	
	gtk_widget_get_allocation( GTK_WIDGET(native), &allocation );
	
	/*
	if ( GTK_IS_LAYOUT( widget ) ) {
		printf( "layout == %d,%d\n", width, height );
	}
	*/
	
	if ( allocation.width != width || allocation.height != height ) {
		printf( "req: %dx%d (%p, currently have %dx%d)\n", width, height, native, allocation.width, allocation.height );
		gtk_widget_set_size_request( GTK_WIDGET(native), width, height );
		
		/*GtkAllocation alloc = allocation;
		alloc.width = req.width;
		alloc.height = req.height;
		gtk_widget_set_allocation( GTK_WIDGET(native), &alloc );*/
	}
	
	int oldX = (int)g_object_get_data( G_OBJECT(widget), "chisel-position-x" );
	int oldY = (int)g_object_get_data( G_OBJECT(widget), "chisel-position-y" );
	
	int newX = (int)frame.origin.x;
	int newY = (int)frame.origin.y;
	
	g_object_set_data( G_OBJECT(widget), "chisel-position-x", COORD_TO_PTR(newX) );
	g_object_set_data( G_OBJECT(widget), "chisel-position-y", COORD_TO_PTR(newY) );
	
	GtkWidget *parent = gtk_widget_get_parent( widget );
	
	if ( parent != NULL && GTK_IS_LAYOUT(parent) ) {
		// reposition child in parent
		GtkLayout *layout = GTK_LAYOUT(parent);
		
		if ( (int)newX != oldX || (int)newY != oldY ) {
			gtk_layout_move( layout, widget, frame.origin.x, frame.origin.y );
		}
	}
}

Rect _chisel_native_view_get_frame( native_handle native ) {
	Rect r;
	
	GtkAllocation allocation;
	
	gtk_widget_get_allocation( GTK_WIDGET(native), &allocation );
	
	r.origin.x = allocation.x;
	r.origin.y = allocation.y;
	r.size.width = allocation.width;
	r.size.height = allocation.height;
	
	//printf( "get frame (%f,%f %fx%f)\n", r.origin.x, r.origin.y, r.size.width, r.size.height );
	
	return r;
}

void _chisel_native_view_invalidate_rect( native_handle native, Rect crect ) {
	//gtk_widget_queue_draw_area( GTK_WIDGET(native), rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
	GdkRectangle rect;
	rect.x = crect.origin.x;
	rect.y = crect.origin.y;
	rect.width = crect.size.width;
	rect.height = crect.size.height;
	gdk_window_invalidate_rect( GTK_WIDGET(native)->window, &rect, FALSE );
}

native_handle _chisel_native_view_get_subviews( native_handle native ) {
	GList *children = gtk_container_get_children( GTK_CONTAINER(native) );
	
	return (native_handle)children;
}
