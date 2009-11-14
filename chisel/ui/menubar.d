module chisel.ui.menubar;

import chisel.core.native;
import chisel.core.cobject;
import chisel.ui.menu;

extern (C) {
	native_handle _chisel_native_menubar_create( );
}

class MenuBar : Menu {
	this( ) {
		this( _chisel_native_menubar_create( ) );
	}
	
	this( native_handle native ) {
		super( native );
	}
}
