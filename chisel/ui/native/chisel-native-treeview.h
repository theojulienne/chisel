native_handle _chisel_native_treeview_create( );

void _chisel_native_treeview_prepare( native_handle native );
void _chisel_native_treeview_reload( native_handle native );

void _chisel_native_treeview_set_reorder_columns( native_handle treeview, int flag );
int _chisel_native_treeview_get_reorder_columns( native_handle treeview );

void _chisel_native_treeview_set_resize_columns( native_handle treeview, int flag );
int _chisel_native_treeview_get_resize_columns( native_handle treeview );

void _chisel_native_treeview_add_column( native_handle treeview, native_handle column );
void _chisel_native_treeview_remove_column( native_handle treeview, native_handle column );
void _chisel_native_treeview_set_outline_column( native_handle treeview, native_handle column );
native_handle _chisel_native_treeview_get_outline_column( native_handle treeview );

uint _chisel_native_treeview_child_count_callback( native_handle treeview, object_handle item );

uint _chisel_native_treeview_item_expandable_callback( native_handle treeview, object_handle item );

object_handle _chisel_native_treeview_child_at_index_callback( native_handle treeview, object_handle item, uint index );

native_handle _chisel_native_treeview_value_for_column_callback( native_handle treeview, object_handle item, native_handle column );
