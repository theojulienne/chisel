module chisel.ui.filesavechooser;

import chisel.core.all;
import chisel.ui.native;
import chisel.ui.window;

extern (C) {
	native_handle _chisel_native_filesavechooser_create( );
	
	void _chisel_native_filesavechooser_set_show_hidden( native_handle chooser, int flag );
	int _chisel_native_filesavechooser_get_show_hidden( native_handle chooser );
	
	void _chisel_native_filesavechooser_set_can_mkdir( native_handle chooser, int flag );
	int _chisel_native_filesavechooser_get_can_mkdir( native_handle chooser );
	
	void _chisel_native_filesavechooser_set_allowed_file_types( native_handle chooser, native_handle types );
	native_handle _chisel_native_filesavechooser_get_allowed_file_types( native_handle chooser );
	
	void _chisel_native_filesavechooser_begin_modal( native_handle chooser, native_handle window );
}

class FileSaveChooser : CObject {
	this( ) {
		super( );
		native = _chisel_native_filesavechooser_create( );
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	bool showsHiddenFiles( ) {
		return _chisel_native_filesavechooser_get_show_hidden( native ) != 0;
	}
	
	void showsHiddenFiles( bool val ) {
		_chisel_native_filesavechooser_set_show_hidden( native, val ? 1 : 0 );
	}
	
	bool canCreateDirectories( ) {
		return _chisel_native_filesavechooser_get_can_mkdir( native ) != 0;
	}
	
	void canCreateDirectories( bool val ) {
		_chisel_native_filesavechooser_set_can_mkdir( native, val ? 1 : 0 );
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
		
		_chisel_native_filesavechooser_set_allowed_file_types( native, arr.native );
	}
	
	String[] allowedFileTypes( ) {
		native_handle narr = _chisel_native_filesavechooser_get_allowed_file_types( native );
		CArray arr = NativeBridge.fromNative!(CArray)( narr );
		
		return arr.toDArray!(String)( );
	}
	
	void beginModal( Window window ) {
		_chisel_native_filesavechooser_begin_modal( native, window.native );
	}
	
	void beginModal( ) {
		_chisel_native_filesavechooser_begin_modal( native, null );
	}
}