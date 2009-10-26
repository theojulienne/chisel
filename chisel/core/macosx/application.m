#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-application.h>

static NSAutoreleasePool *arpool;
static NSObject *app;

void CPSEnableForegroundOperation( ProcessSerialNumber* psn );

void _chisel_native_application_init( ) {
	NSApplicationLoad( );
	
	arpool = [[NSAutoreleasePool alloc] init];
	
	[NSApplication sharedApplication];
	
	[NSApp setMainMenu:[[NSMenu alloc] init]];
	
	app = [[NSObject alloc] init];
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
