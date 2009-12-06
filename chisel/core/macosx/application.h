@interface ChiselApplicationDelegate : NSObject
{}
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification;
- (NSMenuItem *)createAppleMenuItem;
- (void)chiselQuit:(id)item;
@end
