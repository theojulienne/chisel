#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-filesavechooser.h>

@interface CLSavePanel : NSSavePanel
// adds prototypes for 10.6 functions
// these messages should only be sent on 10.6 where they are available
- (void)setShowsHiddenFiles:(BOOL)flag;
- (BOOL)showsHiddenFiles;
@end

@interface ChiselSaveDelegate : NSObject
// delegates
- (void)savePanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
@end

@implementation ChiselSaveDelegate
- (void)savePanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[sheet close];
	
	assert( [[sheet URL] isFileURL] );
	_chisel_native_filesavechooser_completed_callback( (native_handle)sheet, (returnCode == NSFileHandlingPanelOKButton) );
}
@end

native_handle _chisel_native_filesavechooser_create( ) {
	NSSavePanel *panel = [NSSavePanel savePanel];
	
	return (native_handle)panel;
}

void _chisel_native_filesavechooser_set_show_hidden( native_handle chooser, int flag ) {
	CLSavePanel *panel = (CLSavePanel *)chooser;
	
	// 10.6 only
	if ( [panel respondsToSelector:@selector(setShowsHiddenFiles:)] ) {
		[panel setShowsHiddenFiles: flag];
	}
}

int _chisel_native_filesavechooser_get_show_hidden( native_handle chooser ) {
	CLSavePanel *panel = (CLSavePanel *)chooser;
	
	// 10.6 only
	if ( [panel respondsToSelector:@selector(showsHiddenFiles:)] ) {
		return [panel showsHiddenFiles];
	} else {
		return 0;
	}
}

void _chisel_native_filesavechooser_set_can_mkdir( native_handle chooser, int flag ) {
	NSSavePanel *panel = (NSSavePanel *)chooser;
	
	[panel setCanCreateDirectories: flag];
}

int _chisel_native_filesavechooser_get_can_mkdir( native_handle chooser ) {
	NSSavePanel *panel = (NSSavePanel *)chooser;
	
	return [panel canCreateDirectories];
}

void _chisel_native_filesavechooser_set_allowed_file_types( native_handle chooser, native_handle types ) {
	NSSavePanel *panel = (NSSavePanel *)chooser;
	NSArray *arrTypes = (NSArray *)types;
	
	[panel setAllowedFileTypes: arrTypes];
}

native_handle _chisel_native_filesavechooser_get_allowed_file_types( native_handle chooser ) {
	NSSavePanel *panel = (NSSavePanel *)chooser;
	
	return (native_handle)[panel allowedFileTypes];
}

void _chisel_native_filesavechooser_begin_modal( native_handle chooser, native_handle nwindow ) {
	NSSavePanel *panel = (NSSavePanel *)chooser;
	NSWindow *window = (NSWindow *)nwindow;
	
	[panel beginSheetForDirectory:nil
		  	file:nil
			modalForWindow:window
			modalDelegate:[[ChiselSaveDelegate alloc] init]
			didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:)
			contextInfo:nil
			];
}

native_handle _chisel_native_filesavechooser_get_path( native_handle chooser ) {
	NSSavePanel *panel = (NSSavePanel *)chooser;
	
	return (native_handle)[[panel URL] path];
}
