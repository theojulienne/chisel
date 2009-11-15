#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-application.h>
#include <chisel-native-bridge.h>

#include "application.h"
#include "../../ui/macosx/menus.h"

static NSAutoreleasePool *arpool;
static NSObject *app;

void CPSEnableForegroundOperation( ProcessSerialNumber* psn );

@interface NSApplication(Moo)
- (void) setAppleMenu:(ChiselMenu *)menu;
@end

@implementation ChiselApplicationDelegate
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	NSMenuItem *menuItem = [self createAppleMenuItem];
	ChiselMenu *mainMenu = [[[ChiselMenu alloc] init] autorelease];
	[mainMenu addItem:menuItem];
	[NSApp setMainMenu:mainMenu];
	[menuItem release];
}

- (NSMenuItem *)createAppleMenuItem {
	NSString *appName = [[NSProcessInfo processInfo] processName];
	
	NSString *preferredName = (NSString *)_chisel_native_application_name_callback( );

	if ( preferredName != nil ) {
		[preferredName retain];
		appName = preferredName;
		//NSLog( @"%@\n", appName );
	}

	// menu stuff
	ChiselMenu *appleMenu = [[ChiselMenu alloc] initWithTitle:@""];
	NSMenuItem *menuItem;

	ChiselMenu *servicesMenu = [[ChiselMenu alloc] init];
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
	//ChiselMenu *mainMenu = [[[ChiselMenu alloc] init] autorelease];
	//[mainMenu addItem:menuItem];
	//[NSApp setMainMenu:mainMenu];
	//[menuItem release];
	
	[NSApp setAppleMenu:appleMenu];
	[appleMenu release];
	[NSApp setServicesMenu:servicesMenu];
	[servicesMenu release];
	
	[appName release];
	
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
	
	//[NSApp setMainMenu:[[[ChiselMenu alloc] init] autorelease]];
	
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
