#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-splitview.h>

#include <chisel-native-enums.h>

native_handle _chisel_native_splitview_create( int direction ) {
	GtkWidget *widget;
	
	if ( direction == SplitterStackingHorizontal ) {
		widget = gtk_hpaned_new( );
	} else {
		widget = gtk_vpaned_new( );
	}
	
	return (native_handle)widget;
}

void _chisel_native_splitview_set_divider_position( native_handle native, int index, CLFloat position ) {
	
}
