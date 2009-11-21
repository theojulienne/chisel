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
	
	void _chisel_native_tablecolumn_set_identifier( native_handle tablecolumn, native_handle identifier );
	native_handle _chisel_native_tablecolumn_get_identifier( native_handle tablecolumn );
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
	
	void identifier( Object value ) {
		WrappedObject wrapped = new WrappedObject( value );
		_chisel_native_tablecolumn_set_identifier( native, wrapped.native );
	}
	
	Object identifier( ) {
		native_handle wobj = _chisel_native_tablecolumn_get_identifier( native );
		if ( wobj is null )
			return null;
		WrappedObject obj = NativeBridge.fromNative!(WrappedObject)( wobj );
		return cast(Object)obj.object;
	}
}
