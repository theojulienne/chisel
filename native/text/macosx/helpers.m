#include <Cocoa/Cocoa.h>

#include <chisel-native.h>
#include <chisel-native-graphics.h>
#include <chisel-native-font.h>
#include <chisel-native-formattedstring.h>

NSRange CLRangeToNSRange( CLRange range ) {
	return NSMakeRange( range.location, range.length );
} 

CFRange CLRangeToCFRange( CLRange range ) {
	return CFRangeMake( range.location, range.length );
}
