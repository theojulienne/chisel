
typedef void* native_handle;
typedef void* object_handle;

#ifdef _WIN32
typedef unsigned int uint;
#endif

typedef int CLIndex;

typedef struct {
	CLIndex location;
	CLIndex length;
} CLRange;

#define Range CLRange
