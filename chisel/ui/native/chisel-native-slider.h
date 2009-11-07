native_handle _chisel_native_slider_create( );

void _chisel_native_slider_set_minimum( native_handle, CLFloat );
void _chisel_native_slider_set_maximum( native_handle, CLFloat );

void _chisel_native_slider_set_value( native_handle, CLFloat );
CLFloat _chisel_native_slider_get_value( native_handle );

void _chisel_native_slider_changed_callback( native_handle native );
