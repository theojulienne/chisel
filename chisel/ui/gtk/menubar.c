#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-menubar.h>
#include <chisel-native-menu.h>

native_handle _chisel_native_menubar_create( ) {
	return (native_handle)_chisel_native_menu_create( );
}
