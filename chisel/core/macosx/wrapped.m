#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-wrapped.h>

#include "wrapped.h"

@implementation ChiselWrappedObject

- (id)initWithHandle:(object_handle)obj {
	[self setWrappedObject: obj];
	
	return self;
}

- (object_handle)wrappedObject {
	return _handle;
}

- (void)setWrappedObject:(object_handle)obj {
	_handle = obj;
}

@end

native_handle _chisel_native_create_wrapped_object( object_handle handle ) {
	ChiselWrappedObject *obj = [[ChiselWrappedObject alloc] initWithHandle:handle];
	
	return (native_handle)obj;
}
