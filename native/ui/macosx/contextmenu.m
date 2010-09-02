#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-contextmenu.h>
#include <chisel-native-menu.h>

native_handle _chisel_native_contextmenu_create( ) {
	// on mac, there is no difference at all (YAY)
	return _chisel_native_menu_create( );
}
