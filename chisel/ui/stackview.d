module chisel.ui.stackview;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

//import tango.io.Stdout;

enum StackDirection {
	Horizontal,
	Vertical,
}

class StackView : View {
	private StackDirection _stackDirection;
	private double _padding = 0;
	
	private double[View] proportions;
	private double[View] fixedSizes;
	
	this( ) {
		super( );
		direction = StackDirection.Horizontal;
	}
	
	this( StackDirection dir ) {
		super( );
		direction = dir;
	}
	
	this( native_handle hdl ) {
		super( hdl );
	}
	
	void direction( StackDirection dir ) {
		_stackDirection = dir;
	}
	
	StackDirection direction(  ) {
		return _stackDirection;
	}
	
	void padding( double p ) {
		_padding = p;
	}
	
	void setProportion( View subView, double proportion ) {
		if ( proportion < 0 ) {
			setUseHints( subView );
		} else {
			proportions[subView] = proportion;
		}
	}
	
	void setSize( View subView, double size ) {
		if ( size < 0 ) {
			setUseHints( subView );
		} else {
			fixedSizes[subView] = size;
		}
	}
	
	void setUseHints( View subView ) {
		if ( subView in proportions ) {
			proportions.remove( subView );
		}
		
		if ( subView in fixedSizes ) {
			fixedSizes.remove( subView );
		}
	}
	
	private double totalProp( ) {
		double total = 0;
		
		foreach ( prop; proportions ) {
			total += prop;
		}
		
		return total;
	}
	
	private double[View] calculateViewSizes( View[] children ) {
		double[View] result;
		
		double availableSpace;
		
		// find the available space by first taking the full frame size
		if ( direction == StackDirection.Vertical ) {
			availableSpace = this.frame.size.height;
		} else {
			availableSpace = this.frame.size.width;
		}
		
		// now remove the required padding to leave the total child space
		double paddingRequired = _padding * (children.length + 1);
		availableSpace -= paddingRequired;
		
		// calculate the space required for fixed
		double fixedSpace = 0;
		foreach ( child; children ) {
			if ( child in proportions ) {
				// proportional children are ignored here
				continue;
			}
			
			if ( child in fixedSizes ) {
				// child has fixed size in stackview
				fixedSpace += fixedSizes[child];
				result[child] = fixedSizes[child];
				continue;
			}
			
			// otherwise, we're using a size hint for this child
			
			CLFloat childSize;
			
			if ( direction == StackDirection.Vertical ) {
				childSize = child.sizeHint.suggestedSize.height;
			} else {
				childSize = child.sizeHint.suggestedSize.width;
			}
			
			if ( childSize < 0 ) {
				childSize = 0;
			}
			
			// size hint same as fixed size
			fixedSpace += childSize;
			result[child] = childSize;
		}
		
		// find the remaining space for the flexi children
		double flexiSpace = availableSpace - fixedSpace;
		
		// can't give out negative values
		if ( flexiSpace < 0 ) {
			flexiSpace = 0;
		}
		
		double totalProportions = totalProp( );
		
		if ( totalProportions == 0 ) {
			totalProportions = 1;
		}
		
		// divide up the remaining flexible-space to the proportional children
		foreach ( child; children ) {
			if ( child in proportions ) {
				double proportion = proportions[child];
				double scaled = proportion / totalProportions;
				double size = flexiSpace * scaled;
				
				result[child] = size;
			}
		}
		
		return result;
	}
	
	void frameChanged( ) {
		View[] children = this.subviews;
		double[View] sizes = calculateViewSizes( children );
		
		CLFloat growAxis = _padding;
		CLFloat otherAxis = _padding;
		CLFloat otherSize;
		
		if ( direction == StackDirection.Vertical ) {
			otherSize = this.frame.size.width;
		} else {
			otherSize = this.frame.size.height;
		}
		
		foreach ( child; children ) {
			Rect r;
			
			CLFloat childSize = sizes[child];
			
			if ( direction == StackDirection.Vertical ) {
				r.origin.x = otherAxis;
				r.origin.y = growAxis;
				r.size.width = otherSize - (_padding * 2);
				r.size.height = childSize;
			} else {
				r.origin.x = growAxis;
				r.origin.y = otherAxis;
				r.size.width = childSize;
				r.size.height = otherSize - (_padding * 2);
			}
			
			growAxis += childSize + _padding;
			
			//Stdout.formatln( "Child: {} --> {},{} {}x{}", child, r.origin.x, r.origin.y, r.size.width, r.size.height );
			
			child.frame = r;
		}
	}
	
	SizeHint sizeHint( ) {
		SizeHint hint = super.sizeHint( );
		
		View[] children = this.subviews;
		double[View] sizes = calculateViewSizes( children );
		
		double size = _padding;
		
		foreach ( child; children ) {
			double childSize = sizes[child];
			
			size += childSize + _padding;
		}
		
		if ( direction == StackDirection.Vertical ) {
			hint.suggestedSize.height = size;
		} else {
			hint.suggestedSize.width = size;
		}
		
		return hint;
	}
}
