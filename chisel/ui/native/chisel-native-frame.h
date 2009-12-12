native_handle _chisel_native_frame_create( );

void _chisel_native_frame_set_title( native_handle, native_handle );

native_handle _chisel_native_frame_get_content_view( native_handle );
void _chisel_native_frame_set_content_view( native_handle, native_handle );

void _chisel_native_frame_set_border( native_handle native, int flag );
int _chisel_native_frame_get_border( native_handle native );
