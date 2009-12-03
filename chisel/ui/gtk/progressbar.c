#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-progressbar.h>

#include <chisel-native-enums.h>

#include "widgets.h"

#define ANIMATE_UPDATE_INTERVAL 100

void _chisel_native_progressbar_ind_magic( gpointer data ) {
	GtkWidget *widget = GTK_WIDGET(data);
	
	gtk_progress_bar_pulse( GTK_PROGRESS_BAR(widget) );
	
	return g_object_get_data( G_OBJECT(widget), "chisel-progress-animating" );
}

native_handle _chisel_native_progressbar_create( int direction ) {
	GtkWidget *widget = gtk_progress_bar_new( );
	
	if ( direction == ProgressBarTypeHorizontal ) {
		gtk_progress_bar_set_orientation( GTK_PROGRESS_BAR(widget), GTK_PROGRESS_LEFT_TO_RIGHT );
	} else {
		gtk_progress_bar_set_orientation( GTK_PROGRESS_BAR(widget), GTK_PROGRESS_TOP_TO_BOTTOM );
	}
	
	g_object_set_data( G_OBJECT(widget), "chisel-progress-min", malloc(sizeof(CLFloat)) );
	g_object_set_data( G_OBJECT(widget), "chisel-progress-max", malloc(sizeof(CLFloat)) );
	
	_chisel_native_progressbar_set_minimum( widget, 0 );
	_chisel_native_progressbar_set_minimum( widget, 1 );
	
	_chisel_native_progressbar_set_indeterminate( widget, 1 );
	
	return (native_handle)widget;
}

void _chisel_native_progressbar_set_minimum( native_handle native, CLFloat minValue ) {
	CLFloat *min = g_object_get_data( G_OBJECT(native), "chisel-progress-min" );
	
	*min = minValue;
}

void _chisel_native_progressbar_set_maximum( native_handle native, CLFloat maxValue ) {
	CLFloat *max = g_object_get_data( G_OBJECT(native), "chisel-progress-max" );
	
	*max = maxValue;
}

void _chisel_native_progressbar_set_value( native_handle native, CLFloat value ) {
	CLFloat *min = g_object_get_data( G_OBJECT(native), "chisel-progress-min" );
	CLFloat *max = g_object_get_data( G_OBJECT(native), "chisel-progress-max" );
	
	CLFloat range = *max - *min;
	CLFloat fraction = (value - (*min)) / range;
	
	gtk_progress_bar_set_fraction( GTK_PROGRESS_BAR(native), fraction );
	
	_chisel_force_gtk_refresh( );
}

CLFloat _chisel_native_progressbar_get_value( native_handle native ) {
	CLFloat *min = g_object_get_data( G_OBJECT(native), "chisel-progress-min" );
	CLFloat *max = g_object_get_data( G_OBJECT(native), "chisel-progress-max" );
	
	CLFloat range = *max - *min;
	CLFloat fraction = gtk_progress_bar_get_fraction( GTK_PROGRESS_BAR(native) );
	
	return *min + (fraction * range);
}

CLFloat _chisel_native_progressbar_get_thickness( native_handle native ) {
	return 25.0; // FIXME: hax
}

void _chisel_native_progressbar_set_indeterminate( native_handle native, int val ) {
	g_object_set_data( G_OBJECT(native), "chisel-progress-indeterminate", (void*)val );
	if ( !val ) {
		g_object_set_data( G_OBJECT(native), "chisel-progress-animating", (void*)0 );
	}
}

int _chisel_native_progressbar_get_indeterminate( native_handle native ) {
	return (int)g_object_get_data( G_OBJECT(native), "chisel-progress-indeterminate" );
}

void _chisel_native_progressbar_set_animating( native_handle native, int val ) {
	int indeterminate = (int)g_object_get_data( G_OBJECT(native), "chisel-progress-indeterminate" );
	
	if ( indeterminate ) {
		if ( val ) {
			g_timeout_add( ANIMATE_UPDATE_INTERVAL, (GSourceFunc)_chisel_native_progressbar_ind_magic, native );
			g_object_set_data( G_OBJECT(native), "chisel-progress-animating", (void*)1 );
		} else {
			g_object_set_data( G_OBJECT(native), "chisel-progress-animating", (void*)0 );
		}
	}
	
	_chisel_force_gtk_refresh( );
}

int _chisel_native_progressbar_get_animating( native_handle native ) {
	return 0;
}
