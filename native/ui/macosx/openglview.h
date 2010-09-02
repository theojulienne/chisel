@interface ChiselOpenGLView : NSOpenGLView {
}

- (void)update;
- (void)reshape;
- (void)prepareOpenGL;
- (void)drawRect:(NSRect)dirtyRect;

@end
