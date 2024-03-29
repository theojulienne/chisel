module treetest;

version (Tango) {
	import tango.math.Math;
	import tango.io.FilePath;
	import tango.io.Stdout;
	import tango.stdc.posix.dirent;
	import Integer = tango.text.convert.Integer;
} else {
	import std.path;
	import std.file;
	import std.string;
	import std.stdio;
}


import chisel.core.all;
import chisel.graphics.all;
import chisel.text.all;
import chisel.ui.all;

class TreeTestApp : Application {
	Window mainWindow;
	
	TreeView tv;
	
	this( ) {
		mainWindow = new Window( "Tree Test" );
		mainWindow.setSize( 500, 500 );
		
		mainWindow.onClose += &stop;
		
		tv = new TreeView;
		
		tv.onSelectionChanged += &selectionChanged;
		
		tv.dataSource = new FileSystemDataSource( );
		
		auto col = new TableColumn( "Filename" );
		tv.addTableColumn( col );
		tv.outlineTableColumn = col;
		
		auto sizecol = new TableColumn( "Size", String.fromUTF8("size") );
		tv.addTableColumn( sizecol );
		
		mainWindow.contentView = tv;
		
		mainWindow.show( );
	}
	
	void selectionChanged( Event e ) {
		version (Tango)
			Stdout.formatln( "Selection changed: {}", tv.selectedRows );
	}
}

int main( char[][] args ) {
	auto app = new TreeTestApp( );
	app.run( );
	
	
	return 0;
}

class FileSystemDataSource : TreeViewDataSource {
	uint numberOfChildrenOfItem( TreeView treeView, Object item ) {
		FileSystemItem fitem = cast(FileSystemItem)item;
		version (Tango) Stdout.formatln( "numberOfChildrenOfItem {} {}", treeView, item );
		else writefln( "numberOfChildrenOfItem %s %s", treeView, item );
		return ( item is null ) ? 1 : fitem.numberOfChildren;
	}
	
	bool isItemExpandable( TreeView treeView, Object item ) {
		FileSystemItem fitem = cast(FileSystemItem)item;
		version (Tango) Stdout.formatln( "isItemExpandable {} {}", treeView, item );
		else writefln( "isItemExpandable %s %s", treeView, item );
		return ( item is null ) ? true : (fitem.numberOfChildren != -1);
	}
	
	Object childAtIndex( TreeView treeView, Object parent, uint index ) {
		FileSystemItem item = cast(FileSystemItem)parent;
		version (Tango) Stdout.formatln( "childAtIndex {} {} {}", treeView, parent, index );
		else writefln( "childAtIndex %s %s %s", treeView, parent, index );
		return ( parent is null ) ? FileSystemItem.rootItem : item.childAtIndex(index);
	}
	
	CObject valueForTableColumn( TreeView treeView, Object item, TableColumn column ) {
		FileSystemItem fitem = cast(FileSystemItem)item;
		version (Tango) Stdout.formatln( "valueForTableColumn {} {} {}", treeView, item, column );
		else writefln( "valueForTableColumn %s %s %s", treeView, item, column );
		if ( column.identifier is null ) {
			return ( item is null ) ? String.fromUTF8("/") : fitem.relativePath;
		} else {
			return ( item is null || fitem.isFolder ) ? String.fromUTF8("-") : fitem.fileSize;
		}
	}
}

class FileSystemItem {
	static FileSystemItem _rootItem = null;

	static FileSystemItem rootItem( ) {
		if ( _rootItem is null )
			_rootItem = new FileSystemItem( "/" );
		return _rootItem;
	}
	
	version (Tango) {
		FilePath path;
	
		FilePath[] _children;
	} else {
		char[] path;
		
		char[][] _children;
	}
	
	FileSystemItem[] savedChildren;
	
	bool foundChildren = false;
	
	bool noPermissions = false;
	
	this( unicode path ) {
		version (Tango) {
			Stdout.formatln( "FilePath for: {}", path );
			this.path = FilePath( path );
			this.foundChildren = false;
		} else {
			this.path = path;
			
			try {
			
				if ( isdir( path ) ) {
					if ( path[$-1] != '/' ) {
						path ~= "/";
						this.path = path;
					}
					writefln( "list: %s", path );
					this._children = std.file.listdir( path );
				}
			} catch {
				this._children = [];
			}
		}
		
		savedChildren.length = _children.length;
		
		foreach ( i, child; savedChildren ) {
			savedChildren[i] = null;
		}
	}
	
	uint numberOfChildren( ) { // -1 for leaf nodes
		version (Tango) {
			Stdout.formatln( "numberOfChildren isFile={}", path.isFile );
			if ( noPermissions )
				return -1;
			if ( path.isFile )
				return -1;
			return children.length;
		} else {
			try {
				if ( isfile(path) )
					return -1;
			} catch {
				return -1;
			}
			return _children.length;
		}
	}
	
	FileSystemItem childAtIndex( uint index ) {
		if ( savedChildren[index] is null ) {
			version (Tango) {
				savedChildren[index] = new FileSystemItem( children[index].toString );
			} else {
				savedChildren[index] = new FileSystemItem( path ~ _children[index] );
			}
		}
		
		return savedChildren[index];
	}
	
	String relativePath( ) {
		version (Tango) {
			if ( path.name == "" )
				return String.fromUTF8( "/" );
			return String.fromUTF8( path.name );
		} else {
			if ( path[$-1] == '/' && path.length > 1 )
				return String.fromUTF8( getBaseName(path[0..$-1]) );
			if ( path.length > 1 )
				return String.fromUTF8( getBaseName(path) );
			return String.fromUTF8( path );
		}
	}
	
	bool isFolder( ) {
		version (Tango) {
			return path.isFolder;
		} else {
			try {
				return isdir( path ) != 0;
			} catch {
				return false;
			}
		}
	}
	
	String fileSize( ) {
		version (Tango) {
			return String.fromUTF8( Integer.toString(path.fileSize) );//new Number( cast(int)path.fileSize );
		} else {
			try {
				return String.fromUTF8( std.string.toString( getSize( path ) ) );
			} catch {
				return String.fromUTF8( "unknown" );
			}
		}
	}
	
	version (Tango) {
	FilePath[] children( ) {
		if ( !foundChildren ) {
			foundChildren = true;
			
			if ( path.isEmpty )
				return _children;
			
			Stdout.formatln( "Searching {}...", path.toString );
			
			/* TANGO FAIL: in-place patch to detect when tango completely fails at life
			 * path.toList on an empty directory causes an infinite loop because someone
			 * who writes for Tango thinks they are awesome using hacky coding style.
			 */
			DIR* dir = tango.stdc.posix.dirent.opendir( toStringz(path.toString) );
			int count = 0;
			if ( dir ) {
				scope (exit) tango.stdc.posix.dirent.closedir (dir);
			
				dirent entry;
	            dirent* pentry;

				while (readdir_r (dir, &entry, &pentry) == 0 && pentry !is null) {
					auto len = tango.stdc.string.strlen (entry.d_name.ptr);
					auto str = entry.d_name.ptr [0 .. len];
					
					if (str.length > 3 || str != "..."[0 .. str.length]) {
						count++;
					}
				}
			}
			/* END TANGO FAIL */
			
			if ( count > 0 ) {
				try {
					_children = path.toList;
				} catch {
					noPermissions = true;
				}
			}
			
			Stdout.formatln( "done" );
		}
		
		return _children;
	}
	}
}
