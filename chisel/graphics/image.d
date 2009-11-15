module chisel.graphics.image;

import chisel.core.all;

extern (C) {
	native_handle _chisel_native_image_create_from_file( native_handle filename );
	
}

class ImageException : Exception {
	this( unicode msg ) {
		super( msg );
	}
}

class Image : CObject {
	this( String filename ) {
		native_handle n = _chisel_native_image_create_from_file( filename.native );
		
		if ( n is null ) {
			throw new ImageException( "Could not load image: " ~ filename.dString );
		}
		
		this( n );
	}
	
	this( unicode filename ) {
		this( String.fromUTF8( filename ) );
	}
	
	this( native_handle native ) {
		super( native );
	}
}
