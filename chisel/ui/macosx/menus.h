@interface ChiselMenu : NSMenu
- (void)chiselInsertItem:(NSMenuItem *)item atIndex:(uint)index;
- (uint)chiselNumberOfItems;
- (NSMenuItem *)chiselItemAtIndex:(uint)index;

- (NSString *)title;
@end

@interface ChiselMenuBar : ChiselMenu
- (ChiselMenuBar *)initWithTitle:(NSString *)title;
- (void)chiselInsertItem:(NSMenuItem *)item atIndex:(uint)index;
- (uint)chiselNumberOfItems;
- (NSMenuItem *)chiselItemAtIndex:(uint)index;
@end
