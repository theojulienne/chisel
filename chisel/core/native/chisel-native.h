
typedef void* native_handle;
typedef void* object_handle;

typedef int CLIndex;

typedef struct {
	CLIndex location;
	CLIndex length;
} CLRange;

#define Range CLRange