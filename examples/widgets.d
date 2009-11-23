module widgets;

import chisel.core.all;
import chisel.ui.all;

version (Tango) {
	import tango.io.Stdout;
}

class HelloWorldApp : Application {
	Window mainWindow;
	
	StackView groupStackView;
	
	View[unicode] groups;
	
	ProgressBar sliderProgress;
	
	void updateSliderProgress( Event event ) {
		Slider sliderWidget = cast(Slider)event.target;
		sliderProgress.value = sliderWidget.value;
	}
	
	this( ) {
		applicationName = "Chisel Widgets";
		
		mainWindow = new Window( "Hello, Chisel!" );
		mainWindow.setSize( 300, 500 );
		
		MenuBar menubar = new MenuBar( );
		
		MenuItem mi = new MenuItem( "File" );
		Menu exampleSub = new Menu( );
		mi.submenu = exampleSub;
		exampleSub.appendItem( new MenuItem( "Foo" ) );
		menubar.appendItem( mi );
		
		MenuItem mi2 = new MenuItem( "Example" );
		Menu exampleSub2 = new Menu( );
		mi2.submenu = exampleSub2;
		exampleSub2.appendItem( new MenuItem( "Foo" ) );
		menubar.appendItem( mi2 );
		
		mainWindow.menubar = menubar;
		
		
		// create a stack of groups
		groupStackView = new StackView( StackDirection.Vertical );
		groupStackView.padding = 15;
		
		// create our groups
		createGroup( "display", "Displaying Only" );
		createGroup( "interact", "Interactive" );
		
		// show off a label widget
		Label myLabel = new Label( "Hello, I'm a chisel.ui.Label!" );
		showOff( "display", "Label", myLabel );
		
		// show off a progress widget
		ProgressBar myProgress = new ProgressBar( ProgressBarType.Horizontal );
		myProgress.indeterminate = false;
		myProgress.value = 0.5;
		sliderProgress = myProgress;
		showOff( "display", "Progress Bar (Value)", myProgress );
		
		ProgressBar myProgressI = new ProgressBar( ProgressBarType.Horizontal );
		myProgressI.animating = true;
		showOff( "display", "Progress Bar (Indeterminate)", myProgressI );
		
		// show off a button widget
		Button myButton = new Button( "Click here" );
		myButton.onPress += &buttonPressed;
		showOff( "interact", "Button", myButton );
		
		// show off a slider widget
		Slider mySlider = new Slider( SliderType.Horizontal );
		mySlider.value = 0.5;
		mySlider.onChange += &printAction!( "Slider changed!" );
		mySlider.onChange += &updateSliderProgress;
		showOff( "interact", "Slider", mySlider );
		
		// show off a checkbox widget
		CheckBox myCheck = new CheckBox( "Check?" );
		myCheck.onChange += &printAction!( "Check changed!" );
		showOff( "interact", "Check Box", myCheck );
		
		mainWindow.contentView = groupStackView;
		
		mainWindow.onClose += &onWindowCloses;
		
		mainWindow.show( );
	}
	
	void createGroup( unicode code, unicode title ) {
		// start by creating a frame
		auto groupFrame = new Frame( );
		groupFrame.title = title;
		
		groupStackView.addSubview( groupFrame );
		
		// create a stack for this group
		auto groupStack = new StackView( StackDirection.Vertical );
		groupStack.padding = 10;
		
		groupFrame.contentView = groupStack;
		
		// add the group
		groups[code] = groupStack;
	}
	
	void showOff( unicode groupCode, unicode description, View widget ) {
		groups[groupCode].addSubview( new Label( description ) );
		groups[groupCode].addSubview( widget );
	}
	
	int buttonText = 0;
	unicode[] buttonTextItems = [ "Ouch!", "Really, that hurt.", "Please, stop!", "Go away!", "", "", "", "Now you're just being annoying." ];
	
	void buttonPressed( Event e ) {
		Button b = cast(Button)e.target;
		
		if ( buttonText < buttonTextItems.length ) {
			b.text = buttonTextItems[buttonText];
			buttonText++;
		} else {
			b.enabled = false;
		}
	}
	
	void printAction( unicode description )( ) {
		version (Tango) {
			Stdout.formatln( "Action: {}", description );
		}
	}
	
	void onWindowCloses( ) {
		stop( );
	}
}

int main( char[][] args ) {
	auto app = new HelloWorldApp( );
	app.run( );
	
	return 0;
}

