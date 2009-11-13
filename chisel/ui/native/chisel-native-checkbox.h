native_handle _chisel_native_checkbox_create( );

void _chisel_native_checkbox_set_enabled( native_handle, int );
int _chisel_native_checkbox_get_enabled( native_handle );

void _chisel_native_checkbox_set_checked( native_handle, int );
int _chisel_native_checkbox_get_checked( native_handle );

CLFloat _chisel_native_checkbox_get_height( native_handle );

void _chisel_native_checkbox_set_text( native_handle, native_handle );

void _chisel_native_checkbox_changed_callback( native_handle native );
