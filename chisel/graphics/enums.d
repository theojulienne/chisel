module chisel.graphics.enums;

enum AntiAlias {
	Default,
	None,
	Gray,
	SubPixel,
}

enum FillRule {
	Winding=0,
	EvenOdd,
}

enum LineCap {
	Butt=0,
	Round,
	Square,
}

enum LineJoin {
	Miter=0,
	Round,
	Bevel,
}

enum BlendMode {
	Normal=0,
	Multiply,
	Screen,
	Overlay,
	Darken,
	Lighten,
	ColorDodge,
	ColorBurn,
	SoftLight,
	HardLight,
	Difference,
	Exclusion,
	Hue,
	Saturation,
	Color,
	Luminosity,
	
	Clear,
	Copy,
	
	SourceIn,
	SourceOut,
	SourceAtop,
	
	DestinationOver,
	DestinationIn,
	DestinationOut,
	DestinationAtop,

	XOR,
	PlusDarker,
	PlusLighter,
	
}