native_handle _chisel_native_view_create( );
void _chisel_native_view_set_frame( native_handle native, Rect frame );
Rect _chisel_native_view_get_frame( native_handle native );
void _chisel_native_view_add_subview( native_handle native, native_handle subview );
void _chisel_native_view_invalidate_rect( native_handle native, Rect frame );

void _chisel_native_view_draw_rect_callback( native_handle native, Rect rect );
