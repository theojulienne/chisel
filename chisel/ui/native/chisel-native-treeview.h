native_handle _chisel_native_treeview_create( );

void _chisel_native_treeview_set_reorder_columns( native_handle treeview, int flag );
int _chisel_native_treeview_get_reorder_columns( native_handle treeview );

void _chisel_native_treeview_set_resize_columns( native_handle treeview, int flag );
int _chisel_native_treeview_get_resize_columns( native_handle treeview );

void _chisel_native_treeview_add_column( native_handle treeview, native_handle column );
void _chisel_native_treeview_remove_column( native_handle treeview, native_handle column );
