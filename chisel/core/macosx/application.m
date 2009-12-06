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
	NSString *preferredName = (NSString *)_chisel_native_application_name_callback( );
	
	if ( preferredName != nil ) {
		[[NSProcessInfo processInfo] setProcessName:preferredName];
	}
	
	NSString *appName = [[NSProcessInfo processInfo] processName];

	if ( preferredName != nil ) {
		[preferredName retain];
		appName = preferredName;
		//NSLog( @"%@\n", appName );
	}

	// menu stuff
	ChiselMenu *appleMenu = [[ChiselMenu alloc] initWithTitle:appName];
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
			action:@selector(chiselQuit:) 
			keyEquivalent:@"q"];
	[menuItem setTarget:self];
	[appleMenu addItem:menuItem];
	[menuItem release];


	
	menuItem = [[NSMenuItem alloc] initWithTitle:appName action:nil keyEquivalent:@""];
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

- (void)chiselQuit {
	_chisel_native_application_quit_callback( );
}
@end



@interface ChiselObject : NSObject
+ (void) load;

- (void)dealloc;
- (id)retain;
- (oneway void)release;
- (oneway void)chiselRelease;

- (void)chiselComm;
@end

@implementation ChiselObject
+ (void) load {
	// add our ChiselObject in to pose as NSObject
	[self poseAsClass:[NSObject class]];
}

- (void)dealloc {
	//printf( "[%p dealloc] -- beginning\n", self );
	
	_chisel_native_handle_destroyed( self );
	
	//printf( "[%p dealloc] -- nativebridge unregistered\n", self );
	
	[super dealloc];
	
	//printf( "[%p dealloc] -- super dealloced\n", self );
}

- (id)retain {
	id result = [super retain];
	
	int count = [self retainCount];
	
	//NSLog( @"%p retain, retainCount is now: %d\n", self, count );
	[self chiselComm];
	
	return result;
}

- (oneway void)release {
	[self chiselRelease];
}

- (oneway void)chiselRelease {
	int count = [self retainCount];
	
	//NSLog( @"%p release, retainCount will be: %d\n", self, count-1 );
	
	[super release];
	
	// if we would still exist after that release, communicate back to chisel
	if ( count > 1 ) {
		[self chiselComm];
	}
}

- (void)chiselComm {
	_chisel_native_handle_current_references( self, [self retainCount] );
}
@end

void _chisel_native_handle_bridge_registered( native_handle native ) {
	ChiselObject *obj = (ChiselObject *)native;
	
	[obj chiselComm];
}

void _chisel_native_handle_bridge_deregistered( native_handle native ) {
	
}

void _chisel_native_handle_destroy( native_handle native ) {
	ChiselObject *obj = (ChiselObject *)native;
	
	//printf( "_chisel_native_handle_destroy: %p (count=%d)\n", obj, [obj retainCount] );
	
	[obj chiselRelease];
	
	//printf( "released.\n" );
}

void _chisel_native_application_init( ) {
    //printf( "Native app init!\n" );
    
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

void _chisel_native_application_name_updated( ) {
	NSBundle *bundle = [NSBundle mainBundle];
	NSMutableDictionary *info = (NSMutableDictionary *)[bundle infoDictionary];
	
	NSString *preferredName = (NSString *)_chisel_native_application_name_callback( );
	
	assert( preferredName != nil );
	
	[info setObject:preferredName forKey:@"CFBundleName"];
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
