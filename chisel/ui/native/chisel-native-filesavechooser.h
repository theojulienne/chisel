native_handle _chisel_native_filesavechooser_create( );

void _chisel_native_filesavechooser_set_show_hidden( native_handle chooser, int flag );
int _chisel_native_filesavechooser_get_show_hidden( native_handle chooser );

void _chisel_native_filesavechooser_set_can_mkdir( native_handle chooser, int flag );
int _chisel_native_filesavechooser_get_can_mkdir( native_handle chooser );

void _chisel_native_filesavechooser_set_allowed_file_types( native_handle chooser, native_handle types );
native_handle _chisel_native_filesavechooser_get_allowed_file_types( native_handle chooser );

void _chisel_native_filesavechooser_begin_modal( native_handle chooser, native_handle window );

native_handle _chisel_native_filesavechooser_get_path( native_handle chooser );

void _chisel_native_filesavechooser_completed_callback( native_handle native, int success );
