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
}

- (void)prepareOpenGL {
	_chisel_native_openglview_prepare_opengl_callback( self );
}

- (void)drawRect:(NSRect)dirtyRect {
	CLRect rect;
	
	rect.origin.x = dirtyRect.origin.x;
	rect.origin.y = dirtyRect.origin.y;
	rect.size.width = dirtyRect.size.width;
	rect.size.height = dirtyRect.size.height;
	
	_chisel_native_view_draw_rect_callback( self, rect );
}
@end

native_handle _chisel_native_openglview_create( ) {
	ChiselOpenGLView *view = [[ChiselOpenGLView alloc] init];
	assert( view != nil );
	
	return (native_handle)view;
}

native_handle _chisel_native_openglview_opengl_context( native_handle handle ) {
	NSOpenGLView *view = (NSOpenGLView *)handle;
	
	return (native_handle)[view openGLContext];
}
