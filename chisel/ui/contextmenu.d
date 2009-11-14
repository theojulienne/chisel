module chisel.ui.contextmenu;

import chisel.core.cobject;
import chisel.ui.menu;

extern (C) {
	native_handle _chisel_native_contextmenu_create( );
}

class ContextMenu : Menu {
	this( ) {
		this( _chisel_native_contextmenu_create( ) );
	}
	
	this( native_handle native ) {
		super( native );
	}
}
