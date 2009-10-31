#define Size CLSize
#define Point CLPoint
#define Rect CLRect

typedef float CLFloat;

typedef struct {
	CLFloat width;
	CLFloat height;
} CLSize;

typedef struct {
	CLFloat x;
	CLFloat y;
} CLPoint;

typedef struct {
	CLPoint origin;
	CLSize size;
} CLRect;
