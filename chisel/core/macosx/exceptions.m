#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-exceptions.h>

static volatile void _bridge_exception_to_chisel( NSException *e ) {
	char info[1024];
	
	NSString *eName = [e name];
	NSString *eReason = [e reason];
	
	const char *sName = [eName cStringUsingEncoding:NSASCIIStringEncoding];
	const char *sReason = [eReason cStringUsingEncoding:NSASCIIStringEncoding];
	
	sprintf( info, "%s: %s", sName, sReason );
	
	_chisel_native_exception_raised( info );
}

void _chisel_native_exception_bridge_init( ) {
	NSSetUncaughtExceptionHandler( &_bridge_exception_to_chisel );
}
