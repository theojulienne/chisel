module chisel.core.util;

version (Tango) {
	public import tango.text.Util;
	public import tango.stdc.stringz;
	
	// HAX for link errors
	public import tango.stdc.string;
	public import tango.stdc.stdio;
	public import tango.stdc.stdlib;
	public import tango.core.Version;
} else {
	public import std.string;
}