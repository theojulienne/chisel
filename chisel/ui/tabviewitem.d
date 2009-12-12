module chisel.ui.tabviewitem;

import chisel.core.native;
import chisel.core.events;
import chisel.core.string;
import chisel.core.utf;
import chisel.core.cobject;
import chisel.graphics.image;
import chisel.ui.tabview;
import chisel.ui.view;

extern (C) {
	native_handle _chisel_native_tabviewitem_create( );
	
	void _chisel_native_tabviewitem_set_title( native_handle tabviewitem, native_handle title );
	native_handle _chisel_native_tabviewitem_get_title( native_handle tabviewitem );
	
	native_handle _chisel_native_tabviewitem_get_content_view( native_handle );
	void _chisel_native_tabviewitem_set_content_view( native_handle, native_handle );
}

class TabViewItem : CObject {
	EventManager onActivate;
	
	this( ) {
		this( _chisel_native_tabviewitem_create( ) );
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
	
	this( String title, View contentView ) {
		this( title );
		this.contentView = contentView;
	}
	
	this( unicode title, View contentView ) {
		this( title );
		this.contentView = contentView;
	}
	
	void title( String titleText ) {
		_chisel_native_tabviewitem_set_title( native, titleText.native );
	}
	
	void title( unicode titleText ) {
		this.title = String.fromUTF8( titleText );
	}
	
	String title( ) {
		native_handle nTitle = _chisel_native_tabviewitem_get_title( native );
		return NativeBridge.fromNative!(String)( nTitle );
	}
	
	View contentView( ) {
		native_handle native = _chisel_native_tabviewitem_get_content_view( native );
		return NativeBridge.fromNative!(View)( native );
	}
	
	void contentView( View view ) {
		assert( view !is null );
		
		_chisel_native_tabviewitem_set_content_view( native, view.native );
	}
}
