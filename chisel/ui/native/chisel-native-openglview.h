native_handle _chisel_native_openglview_create( );
native_handle _chisel_native_openglview_opengl_context( native_handle );

void _chisel_native_openglview_prepare_opengl_callback( native_handle native );

void _chisel_native_openglview_reshape_callback( native_handle native );

void _chisel_native_openglview_update_callback( native_handle native );
