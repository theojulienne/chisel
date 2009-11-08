#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-array.h>

uint _chisel_native_array_get_length( native_handle native ) {
	NSArray *arr = (NSArray *)native;
	
	return [arr count];
}

native_handle _chisel_native_array_get_object( native_handle native, uint index ) {
	NSArray *arr = (NSArray *)native;
	
	return (native_handle)[arr objectAtIndex:index];
}
