native_handle _chisel_native_window_create( );

void _chisel_native_window_set_title( native_handle, native_handle str );

void _chisel_native_window_set_visible( native_handle, int );

void _chisel_native_window_set_content_size( native_handle, Size );

native_handle _chisel_native_window_get_content_view( native_handle );
void _chisel_native_window_set_content_view( native_handle, native_handle );

void _chisel_native_window_close( native_handle );
void _chisel_native_window_will_close_callback( native_handle native );

void _chisel_native_window_set_menubar( native_handle window, native_handle menubar );
native_handle _chisel_native_window_get_menubar( native_handle window );

