module chisel.core.utf;

alias char[] unicode;

version (Tango) {
	import tango.stdc.stringz;
	alias tango.stdc.stringz.fromStringz fromStringz;
} else {
	import std.string;
	alias std.string.toString fromStringz;
}