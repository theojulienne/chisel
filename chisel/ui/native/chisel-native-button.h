native_handle _chisel_native_button_create( );

void _chisel_native_button_set_enabled( native_handle, int );
int _chisel_native_button_get_enabled( native_handle );

CLFloat _chisel_native_button_get_height( native_handle );

void _chisel_native_button_set_text( native_handle, native_handle );

void _chisel_native_button_pressed_callback( native_handle native );
