native_handle _chisel_native_tabview_create( );

void _chisel_native_tabview_insert_item( native_handle tabview, uint index, native_handle item );
void _chisel_native_tabview_remove_item( native_handle tabview, native_handle item );
uint _chisel_native_tabview_item_count( native_handle tabview );
native_handle _chisel_native_tabview_item_get( native_handle tabview, uint index );

void _chisel_native_tabview_select_item( native_handle tabview, native_handle item );
native_handle _chisel_native_tabview_get_selected_item( native_handle tabview );
