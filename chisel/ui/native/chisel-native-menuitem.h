native_handle _chisel_native_menuitem_create( );
native_handle _chisel_native_menuitem_create_separator( );

void _chisel_native_menuitem_set_submenu( native_handle menuitem, native_handle submenu );
native_handle _chisel_native_menuitem_get_submenu( native_handle menuitem );

void _chisel_native_menuitem_set_enabled( native_handle menuitem, int flag );
int _chisel_native_menuitem_get_enabled( native_handle menuitem );

void _chisel_native_menuitem_set_visible( native_handle menuitem, int flag );
int _chisel_native_menuitem_get_visible( native_handle menuitem );

void _chisel_native_menuitem_set_title( native_handle menuitem, native_handle title );
native_handle _chisel_native_menuitem_get_title( native_handle menuitem );

void _chisel_native_menuitem_pressed_callback( native_handle native );

void _chisel_native_menuitem_set_key_equivalent( native_handle menuitem, native_handle key );
native_handle _chisel_native_menuitem_get_key_equivalent( native_handle menuitem );

void _chisel_native_menuitem_set_key_equivalent_modifiers( native_handle menuitem, int modifiers );
int _chisel_native_menuitem_get_key_equivalent_modifiers( native_handle menuitem );
