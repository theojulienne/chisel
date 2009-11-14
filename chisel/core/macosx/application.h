@interface ChiselApplicationDelegate : NSObject
{}
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification;
- (NSMenuItem *)createAppleMenuItem;
@end
