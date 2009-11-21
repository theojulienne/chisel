#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-tablecolumn.h>

#include "../../core/macosx/wrapped.h"

native_handle _chisel_native_tablecolumn_create( ) {
	NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier: nil];
	
	[tableColumn setEditable: NO];
	
	return (native_handle)tableColumn;
}

void _chisel_native_tablecolumn_set_title( native_handle ntablecolumn, native_handle ntitle ) {
	NSTableColumn *tableColumn = (NSTableColumn *)ntablecolumn;
	NSString *title = (NSString *)ntitle;
	
	[[tableColumn headerCell] setStringValue: title];
}

native_handle _chisel_native_tablecolumn_get_title( native_handle ntablecolumn ) {
	NSTableColumn *tableColumn = (NSTableColumn *)ntablecolumn;
	
	return (native_handle)[[[tableColumn headerCell] stringValue] retain];
}

void _chisel_native_tablecolumn_set_identifier( native_handle ntablecolumn, native_handle identifier ) {
	NSTableColumn *tableColumn = (NSTableColumn *)ntablecolumn;
	ChiselWrappedObject *wrapped = (ChiselWrappedObject *)identifier;
	
	[tableColumn setIdentifier: wrapped];
}

native_handle _chisel_native_tablecolumn_get_identifier( native_handle ntablecolumn ) {
	NSTableColumn *tableColumn = (NSTableColumn *)ntablecolumn;
	
	ChiselWrappedObject *ci = (ChiselWrappedObject *)[tableColumn identifier];
	
	return (native_handle)ci;
}
