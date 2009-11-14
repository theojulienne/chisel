native_handle _chisel_native_menu_create( );

void _chisel_native_menu_insert_item( native_handle menu, uint index, native_handle item );
uint _chisel_native_menu_item_count( native_handle menu );
native_handle _chisel_native_menu_item_get( native_handle menu, uint index );
