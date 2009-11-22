void _chisel_native_graphicscontext_save_graphics_state( native_handle );
void _chisel_native_graphicscontext_restore_graphics_state( native_handle );
//void _chisel_native_graphicscontext_set_current_context( native_handle );
native_handle _chisel_native_graphicscontext_get_current_context( );

void _chisel_native_graphicscontext_begin_path( native_handle );
void _chisel_native_graphicscontext_move_to_point( native_handle, CLFloat x, CLFloat y );
void _chisel_native_graphicscontext_line_to_point( native_handle, CLFloat x, CLFloat y );
void _chisel_native_graphicscontext_curve_to_point( native_handle, CLFloat cp1X, CLFloat cp1Y, CLFloat cp2X, CLFloat cp2Y, CLFloat endX, CLFloat endY );
void _chisel_native_graphicscontext_close_path( native_handle );

void _chisel_native_graphicscontext_stroke_path( native_handle );
void _chisel_native_graphicscontext_fill_path( native_handle );

void _chisel_native_graphicscontext_translate( native_handle, CLFloat x, CLFloat y );
