native_handle _chisel_native_progressbar_create( );

void _chisel_native_progressbar_set_minimum( native_handle, CLFloat );
void _chisel_native_progressbar_set_maximum( native_handle, CLFloat );

CLFloat _chisel_native_progressbar_get_thickness( native_handle );

void _chisel_native_progressbar_set_value( native_handle, CLFloat );
CLFloat _chisel_native_progressbar_get_value( native_handle );
