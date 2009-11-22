native_handle _chisel_native_fileopenchooser_create( );

void _chisel_native_fileopenchooser_set_show_hidden( native_handle chooser, int flag );
int _chisel_native_fileopenchooser_get_show_hidden( native_handle chooser );

void _chisel_native_fileopenchooser_set_can_mkdir( native_handle chooser, int flag );
int _chisel_native_fileopenchooser_get_can_mkdir( native_handle chooser );

void _chisel_native_fileopenchooser_set_can_choose_files( native_handle chooser, int flag );
int _chisel_native_fileopenchooser_get_can_choose_files( native_handle chooser );

void _chisel_native_fileopenchooser_set_can_choose_directories( native_handle chooser, int flag );
int _chisel_native_fileopenchooser_get_can_choose_directories( native_handle chooser );

void _chisel_native_fileopenchooser_set_allows_multiple( native_handle chooser, int flag );
int _chisel_native_fileopenchooser_get_allows_multiple( native_handle chooser );

void _chisel_native_fileopenchooser_set_allowed_file_types( native_handle chooser, native_handle types );
native_handle _chisel_native_fileopenchooser_get_allowed_file_types( native_handle chooser );

void _chisel_native_fileopenchooser_begin_modal( native_handle chooser, native_handle window );

native_handle _chisel_native_fileopenchooser_get_paths( native_handle chooser );

void _chisel_native_fileopenchooser_completed_callback( native_handle native, int success );
