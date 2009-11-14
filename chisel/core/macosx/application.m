#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-application.h>
#include <chisel-native-bridge.h>

static NSAutoreleasePool *arpool;
static NSObject *app;

void CPSEnableForegroundOperation( ProcessSerialNumber* psn );

@interface NSApplication(Moo)
- (void) setAppleMenu:(NSMenu *)menu;
@end

@interface ChiselApplicationDelegate : NSObject
{}
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification;
- (NSMenuItem *)createAppleMenuItem;
@end

@implementation ChiselApplicationDelegate
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	NSMenuItem *menuItem = [self createAppleMenuItem];
	
	NSMenu *mainMenu = [[[NSMenu alloc] init] autorelease];
	[mainMenu addItem:menuItem];
	[NSApp setMainMenu:mainMenu];
	[menuItem release];
}

- (NSMenuItem *)createAppleMenuItem {
	NSString *appName = [[NSProcessInfo processInfo] processName];
	
	// menu stuff
	NSMenu *appleMenu = [[NSMenu alloc] initWithTitle:@""];
	NSMenuItem *menuItem;
	
	NSMenu *servicesMenu = [[NSMenu alloc] init];
	NSMenuItem *servItem = [[NSMenuItem alloc] initWithTitle:@"Services" action:nil keyEquivalent:@""];
	[servItem setSubmenu:servicesMenu];
	[appleMenu addItem:servItem];
	[servItem release];
	
	[appleMenu addItem:[NSMenuItem separatorItem]];
	
	menuItem = [[NSMenuItem alloc]
			initWithTitle:[@"Hide " stringByAppendingString:appName]
			action:@selector(hide:)
			keyEquivalent:@"h"];
	[menuItem setTarget:NSApp];
	[appleMenu addItem:menuItem];
	[menuItem release];

	menuItem = [[NSMenuItem alloc]
			initWithTitle:@"Hide Others" 
			action:@selector(hideOtherApplications:) 
			keyEquivalent:@"h"];
	[menuItem setKeyEquivalentModifierMask:
		(NSAlternateKeyMask | NSCommandKeyMask)];
	[menuItem setTarget:NSApp];
	[appleMenu addItem:menuItem];
	[menuItem release];

	menuItem = [[NSMenuItem alloc]
			initWithTitle:@"Show All" 
			action:@selector(unhideAllApplications:) 
			keyEquivalent:@""];
	[menuItem setTarget:NSApp];
	[appleMenu addItem:menuItem];
	[menuItem release];

	[appleMenu addItem:[NSMenuItem separatorItem]];
	
	menuItem = [[NSMenuItem alloc]
			initWithTitle:[@"Quit " stringByAppendingString:appName]
			action:@selector(terminate:) 
			keyEquivalent:@"q"];
	[menuItem setTarget:NSApp];
	[appleMenu addItem:menuItem];
	[menuItem release];


	
	menuItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
	[menuItem setSubmenu:appleMenu];
	//NSMenu *mainMenu = [[[NSMenu alloc] init] autorelease];
	//[mainMenu addItem:menuItem];
	//[NSApp setMainMenu:mainMenu];
	//[menuItem release];
	
	[NSApp setAppleMenu:appleMenu];
	[appleMenu release];
	[NSApp setServicesMenu:servicesMenu];
	[servicesMenu release];
	
	return menuItem;
}
@end



@interface ChiselObject : NSObject
- (void)dealloc;
@end

@implementation ChiselObject
- (void)dealloc {
	//printf( "[%p dealloc] -- beginning\n", self );
	
	_chisel_native_handle_destroyed( self );
	
	//printf( "[%p dealloc] -- nativebridge unregistered\n", self );
	
	[super dealloc];
	
	//printf( "[%p dealloc] -- super dealloced\n", self );
}
@end

void _chisel_native_handle_destroy( native_handle native ) {
	NSObject *obj = (NSObject *)native;
	
	//printf( "_chisel_native_handle_destroy: %p\n", obj );
	
	[obj release];
	
	//printf( "released.\n" );
}

void _chisel_native_application_init( ) {
    //printf( "Native app init!\n" );

	// add our ChiselObject in to pose as NSObject
	[ChiselObject poseAsClass:[NSObject class]];
    
	//NSApplicationLoad( );
	
	arpool = [[NSAutoreleasePool alloc] init];
	
	[NSApplication sharedApplication];
	
	//[NSApp setMainMenu:[[[NSMenu alloc] init] autorelease]];
	
	app = [[[ChiselApplicationDelegate alloc] init] autorelease];
	[NSApp setDelegate: app];
	
	// let Finder know we're here
	ProcessSerialNumber myProc, frProc;
	Boolean sameProc;
	
	if ( GetFrontProcess( &frProc ) == noErr && GetCurrentProcess( &myProc ) == noErr )
	{
		if ( SameProcess( &frProc, &myProc, &sameProc ) == noErr && !sameProc )
		{
			CPSEnableForegroundOperation( &myProc );
		}
		
		SetFrontProcess( &myProc );
	}
}

void _chisel_native_application_run( ) {
	[NSApp run];
}

void _chisel_native_application_stop( ) {
	[NSApp stop: nil];
}


@interface ChiselAppFire : NSObject
{}

- (void)idleTask;
@end

@implementation ChiselAppFire
- (void)idleTask {
	_chisel_native_application_idle_task_callback( );
}
@end

void _chisel_native_application_set_use_idle_task( int status ) {
	static NSTimer *timer = nil;
	
	// if timer enabled but currently not set, create+enable
	if ( status && timer == nil ) {
		timer = [[NSTimer scheduledTimerWithTimeInterval:0.001f
			target:[[ChiselAppFire alloc] init]
			selector:@selector( idleTask )
			userInfo:nil
			repeats:YES
		] retain];
		
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSEventTrackingRunLoopMode];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSModalPanelRunLoopMode];
	}
	
	// if timer disabled but currently set, invalidate
	if ( !status && timer != nil ) {
		[timer invalidate];
		
		timer = nil;
	}
}
