@interface ChiselView : NSView {
}

- (BOOL)isFlipped;
- (void)drawRect:(NSRect)dirtyRect;
- (void)setFrame:(NSRect)frameRect;
@end
