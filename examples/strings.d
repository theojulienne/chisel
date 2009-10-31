module examples.strings;

import chisel.core.string;

char[] snowman = "☃";

extern (C) void printf( char*, ... );

void main( ) {
	String s = String.withUTF8( snowman );
	
	// unicode snowman is 1 unicode character, but takes 3 bytes
	assert( s.length == 1 && snowman.length == 3 );
	
	// check for equality between utf8 and String
	assert( s == snowman );
	
	// check for inequality between utf8 and String
	assert( s != "oh hai" );
}