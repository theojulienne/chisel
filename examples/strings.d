module examples.strings;

import chisel.core.string;

char[] snowman = "☃";

version (Tango) {
	import tango.stdc.stdio;
	import tango.core.Memory;
}

void testStrings( ) {
	String s = String.withUTF8( snowman );
	
	// unicode snowman is 1 unicode character, but takes 3 bytes
	assert( s.length == 1 && snowman.length == 3 );
	
	// check for equality between utf8 and String
	assert( s == snowman );
	
	// check for inequality between utf8 and String
	assert( s != "oh hai" );
	
	//delete s;
}

void main( ) {
	testStrings( );
	
	version (Tango) {
		printf( "Running collect...\n" );
		GC.collect( );
	}
}