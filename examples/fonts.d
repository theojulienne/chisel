module examples.fonts;

import chisel.core.string;
import chisel.text.all;

extern (C) void printf( char*, ... );

void main( ) {
	Font f = Font.createWithName( "Verdana", 16 );
	
	printf( "Font full name: %s\n", f.fullName.cString );
	printf( "Font family name: %s\n", f.familyName.cString );
	printf( "Font size: %.1f\n", f.size );
}