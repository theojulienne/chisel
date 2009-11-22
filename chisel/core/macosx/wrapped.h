@interface ChiselWrappedObject : NSObject
{
	object_handle _handle;
}

- (id)initWithHandle:(object_handle)obj;
- (object_handle)wrappedObject;
- (void)setWrappedObject:(object_handle)obj;
@end

