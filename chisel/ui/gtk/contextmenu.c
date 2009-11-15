#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-contextmenu.h>
#include <chisel-native-menu.h>

native_handle _chisel_native_contextmenu_create( ) {
	return _chisel_native_menu_create( );
}
