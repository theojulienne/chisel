#include <Cocoa/Cocoa.h>
#include <assert.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-openglview.h>

#include "openglview.h"

@implementation ChiselOpenGLView

- (void)update {
	_chisel_native_openglview_update_callback( self );
}

- (void)reshape {
	_chisel_native_openglview_reshape_callback( self );
	
	[self update];
}

- (void)prepareOpenGL {
	_chisel_native_openglview_prepare_opengl_callback( self );
}

- (void)drawRect:(NSRect)dirtyRect {
	Rect rect;
	
	rect.origin.x = dirtyRect.origin.x;
	rect.origin.y = dirtyRect.origin.y;
	rect.size.width = dirtyRect.size.width;
	rect.size.height = dirtyRect.size.height;
	
	_chisel_native_view_draw_rect_callback( self, rect );
}
@end

native_handle _chisel_native_openglview_create( ) {
	NSRect frame = NSMakeRect( 0, 0, 10, 10 );
	
	NSOpenGLPixelFormatAttribute attr[] = {
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFAAccelerated,
		NSOpenGLPFAColorSize, 32,
		NSOpenGLPFADepthSize, 16,
		0
	};
	
	NSOpenGLPixelFormat *format = [[NSOpenGLPixelFormat alloc] initWithAttributes:attr];
	
	ChiselOpenGLView *view = [[ChiselOpenGLView alloc] initWithFrame:frame pixelFormat:format];
	assert( view != nil );
	
	[format release];
	
	return (native_handle)view;
}

native_handle _chisel_native_openglview_opengl_context( native_handle handle ) {
	NSOpenGLView *view = (NSOpenGLView *)handle;
	
	return (native_handle)[view openGLContext];
}
