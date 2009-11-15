#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-image.h>

native_handle _chisel_native_image_create_from_file( native_handle nFilename ) {
	NSString *filename = (NSString *)nFilename;
	NSImage *image = [[NSImage alloc] initWithContentsOfFile: filename];
	
	return (native_handle)image;
}
