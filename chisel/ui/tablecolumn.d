module chisel.ui.tablecolumn;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;
import chisel.ui.treeview;

extern (C) {
	native_handle _chisel_native_tablecolumn_create( );
	
	void _chisel_native_tablecolumn_set_title( native_handle tablecolumn, native_handle title );
	native_handle _chisel_native_tablecolumn_get_title( native_handle tablecolumn );
	
	void _chisel_native_tablecolumn_set_identifier( native_handle tablecolumn, object_handle identifier );
	object_handle _chisel_native_tablecolumn_get_identifier( native_handle tablecolumn );
}

class TableColumn : CObject {
	this( ) {
		this( _chisel_native_tablecolumn_create( ) );
	}
	
	this( native_handle native ) {
		super( native );
	}
	
	this( String title ) {
		this( );
		this.title = title;
	}
	
	this( unicode title ) {
		this( );
		this.title = title;
	}
	
	this( String title, Object identifier ) {
		this( title );
		this.identifier = identifier;
	}
	
	this( unicode title, Object identifier ) {
		this( title );
		this.identifier = identifier;
	}
	
	this( String title, object_handle identifier ) {
		this( title );
		this.identifier = identifier;
	}
	
	this( unicode title, object_handle identifier ) {
		this( title );
		this.identifier = identifier;
	}
	
	void title( String titleText ) {
		_chisel_native_tablecolumn_set_title( native, titleText.native );
	}
	
	void title( unicode titleText ) {
		this.title = String.fromUTF8( titleText );
	}
	
	String title( ) {
		native_handle nTitle = _chisel_native_tablecolumn_get_title( native );
		return NativeBridge.fromNative!(String)( nTitle );
	}
	
	void identifier( object_handle value ) {
		_chisel_native_tablecolumn_set_identifier( native, value );
	}
	
	void identifier( Object value ) {
		// FIXME: "value" must be set to not be relocated by the GC, otherwise it will become invalid
		identifier = cast(object_handle)value;
	}
	
	Object identifier( ) {
		return cast(Object)_chisel_native_tablecolumn_get_identifier( native );
	}
}
