module chisel.ui.stackview;

import chisel.core.all;
import chisel.graphics.context;
import chisel.ui.native;
import chisel.ui.view;

enum StackDirection {
	Horizontal,
	Vertical,
}

class StackView : View {
	StackDirection _stackDirection;
	double _padding;
	
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
	
	void frameChanged( ) {
		View[] children = this.subviews;
		
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
			
			CLFloat childSize;
			
			if ( direction == StackDirection.Vertical ) {
				childSize = child.sizeHint.suggestedSize.height;
			} else {
				childSize = child.sizeHint.suggestedSize.width;
			}
			
			if ( childSize < 0 ) {
				childSize = 0;
			}
			
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
			
			child.frame = r;
		}
		
	}
	
	SizeHint sizeHint( ) {
		SizeHint hint = super.sizeHint( );
		
		View[] children = this.subviews;
		double size = _padding;
		
		foreach ( child; children ) {
			double childSize;
			
			if ( direction == StackDirection.Vertical ) {
				childSize = child.sizeHint.suggestedSize.height;
			} else {
				childSize = child.sizeHint.suggestedSize.width;
			}
			
			if ( childSize < 0 ) {
				childSize = 0;
			}
			
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
