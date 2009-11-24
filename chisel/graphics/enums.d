module chisel.graphics.enums;

enum AntiAlias {
	Default,
	None,
	Gray,
	SubPixel,
}

enum FillRule {
	Winding,
	EvenOdd,
}

enum LineCap {
	Butt,
	Round,
	Square,
}

enum LineJoin {
	Miter,
	Round,
	Bevel,
}

enum BlendMode {
	Normal,
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