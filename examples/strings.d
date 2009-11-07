module examples.strings;

import chisel.core.string;

char[] snowman = "☃";

version (Tango) import tango.core.Memory;

void main( ) {
	String s = String.withUTF8( snowman );
	
	// unicode snowman is 1 unicode character, but takes 3 bytes
	assert( s.length == 1 && snowman.length == 3 );
	
	// check for equality between utf8 and String
	assert( s == snowman );
	
	// check for inequality between utf8 and String
	assert( s != "oh hai" );
	
	version (Tango) GC.collect( );
}