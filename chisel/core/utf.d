module chisel.core.utf;

alias char[] unicode;

version (Tango) {
	import tango.stdc.stringz;
	import tango.stdc.stdlib;
	import tango.stdc.stdio;
	
	alias tango.stdc.stringz.fromStringz fromStringz;
	
	alias tango.stdc.stdio.printf printf;
} else {
	import std.string;
	alias std.string.toString fromStringz;
}

unicode copyFreeingStringz( char* str ) {
	unicode result = fromStringz( str ).dup;
	
	// free the original string
	free( str );
	
	return result;
}