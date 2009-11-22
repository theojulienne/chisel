module chisel.ui.fileopenchooser;

import chisel.core.all;
import chisel.ui.native;
import chisel.ui.window;

extern (C) {
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
	
	void _chisel_native_fileopenchooser_completed_callback( native_handle native, int success ) {
		FileOpenChooser chooser = cast(FileOpenChooser)NativeBridge.forNative( native );
		assert( chooser !is null );
		
		chooser.completed( success != 0 );
	}
}

class FileOpenChooser : CObject {
	EventManager onCompleted;
	bool fileWasChosen = false;
	
	this( ) {
		super( );
		native = _chisel_native_fileopenchooser_create( );
	}
	
	this( native_handle native ) {
		super( native );
		
		// defaults
		this.canCreateDirectories = true;
		this.canChooseFiles = true;
		this.canChooseDirectories = false;
		this.allowsMultipleSelection = false;
	}
	
	bool showsHiddenFiles( ) {
		return _chisel_native_fileopenchooser_get_show_hidden( native ) != 0;
	}
	
	void showsHiddenFiles( bool val ) {
		_chisel_native_fileopenchooser_set_show_hidden( native, val ? 1 : 0 );
	}
	
	bool canCreateDirectories( ) {
		return _chisel_native_fileopenchooser_get_can_mkdir( native ) != 0;
	}
	
	void canCreateDirectories( bool val ) {
		_chisel_native_fileopenchooser_set_can_mkdir( native, val ? 1 : 0 );
	}
	
	bool canChooseFiles( ) {
		return _chisel_native_fileopenchooser_get_can_choose_files( native ) != 0;
	}
	
	void canChooseFiles( bool val ) {
		_chisel_native_fileopenchooser_set_can_choose_files( native, val ? 1 : 0 );
	}
	
	bool canChooseDirectories( ) {
		return _chisel_native_fileopenchooser_get_can_choose_directories( native ) != 0;
	}
	
	void canChooseDirectories( bool val ) {
		_chisel_native_fileopenchooser_set_can_choose_directories( native, val ? 1 : 0 );
	}
	
	bool allowsMultipleSelection( ) {
		return _chisel_native_fileopenchooser_get_allows_multiple( native ) != 0;
	}
	
	void allowsMultipleSelection( bool val ) {
		_chisel_native_fileopenchooser_set_allows_multiple( native, val ? 1 : 0 );
	}
	
	void allowedFileTypes( unicode[] fileTypes ) {
		String[] native;
		native.length = fileTypes.length;
		
		foreach ( i, fileType; fileTypes ) {
			native[i] = String.fromUTF8( fileType );
		}
		
		allowedFileTypes = native;
	}
	
	void allowedFileTypes( String[] fileTypes ) {
		CArray arr = CArray.withObjects( fileTypes );
		
		_chisel_native_fileopenchooser_set_allowed_file_types( native, arr.native );
	}
	
	String[] allowedFileTypes( ) {
		native_handle narr = _chisel_native_fileopenchooser_get_allowed_file_types( native );
		CArray arr = NativeBridge.fromNative!(CArray)( narr );
		
		return arr.toDArray!(String)( );
	}
	
	void beginModal( Window window ) {
		_chisel_native_fileopenchooser_begin_modal( native, window.native );
	}
	
	void beginModal( ) {
		_chisel_native_fileopenchooser_begin_modal( native, null );
	}
	
	void completed( bool fileWasChosen ) {
		this.fileWasChosen = fileWasChosen;
		onCompleted.call( this );
	}
	
	String[] chosenPaths( ) {
		native_handle narr = _chisel_native_fileopenchooser_get_paths( native );
		CArray arr = NativeBridge.fromNative!(CArray)( narr );
		
		return arr.toDArray!(String)( );
	}
	
	String chosenPath( ) {
		return chosenPaths[0];
	}
}