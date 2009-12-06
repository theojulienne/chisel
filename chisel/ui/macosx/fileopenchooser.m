#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-fileopenchooser.h>

@interface CLOpenPanel : NSOpenPanel
// adds prototypes for 10.6 functions
// these messages should only be sent on 10.6 where they are available
- (void)setShowsHiddenFiles:(BOOL)flag;
- (BOOL)showsHiddenFiles;
@end

@interface ChiselOpenDelegate : NSObject
// delegates
- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
@end

@implementation ChiselOpenDelegate
- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[sheet close];
	
	assert( (returnCode != NSFileHandlingPanelOKButton) || [[sheet URL] isFileURL] );
	_chisel_native_fileopenchooser_completed_callback( (native_handle)sheet, (returnCode == NSFileHandlingPanelOKButton) );
}
@end

native_handle _chisel_native_fileopenchooser_create( ) {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	
	return (native_handle)panel;
}

void _chisel_native_fileopenchooser_set_show_hidden( native_handle chooser, int flag ) {
	CLOpenPanel *panel = (CLOpenPanel *)chooser;
	
	// 10.6 only
	if ( [panel respondsToSelector:@selector(setShowsHiddenFiles:)] ) {
		[panel setShowsHiddenFiles: flag];
	}
}

int _chisel_native_fileopenchooser_get_show_hidden( native_handle chooser ) {
	CLOpenPanel *panel = (CLOpenPanel *)chooser;
	
	// 10.6 only
	if ( [panel respondsToSelector:@selector(showsHiddenFiles:)] ) {
		return [panel showsHiddenFiles];
	} else {
		return 0;
	}
}

void _chisel_native_fileopenchooser_set_can_mkdir( native_handle chooser, int flag ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	
	[panel setCanCreateDirectories: flag];
}

int _chisel_native_fileopenchooser_get_can_mkdir( native_handle chooser ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	
	return [panel canCreateDirectories];
}

void _chisel_native_fileopenchooser_set_allows_multiple( native_handle chooser, int flag ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	
	[panel setAllowsMultipleSelection: flag];
}

int _chisel_native_fileopenchooser_get_allows_multiple( native_handle chooser ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	
	return [panel allowsMultipleSelection];
}

void _chisel_native_fileopenchooser_set_can_choose_files( native_handle chooser, int flag ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	
	[panel setCanChooseFiles: flag];
}

int _chisel_native_fileopenchooser_get_can_choose_files( native_handle chooser ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	
	return [panel canChooseFiles];
}

void _chisel_native_fileopenchooser_set_can_choose_directories( native_handle chooser, int flag ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	
	[panel setCanChooseDirectories: flag];
}

int _chisel_native_fileopenchooser_get_can_choose_directories( native_handle chooser ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	
	return [panel canChooseDirectories];
}

void _chisel_native_fileopenchooser_set_allowed_file_types( native_handle chooser, native_handle types ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	NSArray *arrTypes = (NSArray *)types;
	
	[panel setAllowedFileTypes: arrTypes];
}

native_handle _chisel_native_fileopenchooser_get_allowed_file_types( native_handle chooser ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	
	return (native_handle)[panel allowedFileTypes];
}

void _chisel_native_fileopenchooser_begin_modal( native_handle chooser, native_handle nwindow ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	NSWindow *window = (NSWindow *)nwindow;
	
	[panel beginSheetForDirectory:nil
		  	file:nil
			modalForWindow:window
			modalDelegate:[[ChiselOpenDelegate alloc] init]
			didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
			contextInfo:nil
			];
}

native_handle _chisel_native_fileopenchooser_get_paths( native_handle chooser ) {
	NSOpenPanel *panel = (NSOpenPanel *)chooser;
	NSArray *urls = [panel URLs];
	NSMutableArray *paths = [NSMutableArray arrayWithCapacity:[urls count]];
	int i;
	
	for ( i = 0; i < [urls count]; i++ ) {
		NSURL *url = [urls objectAtIndex:i];
		[paths addObject: [url path]];
	}
	
	return (native_handle)paths;
}
