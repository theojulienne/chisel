from java.namespace import Namespace
from java.types import *

Chisel = Namespace( 'Chisel' )

## core ##

Core = Chisel.addNamespace( 'Core' )

CObject = Core.addPremadeClass( 'CObject' )

Application = Core.addClass( 'Application', superclass=CObject )
Application.addSharedInstance( 'sharedApplication' )
Application.addProperty( 'applicationName', StringType )
Application.addProperty( 'useIdleTask', BooleanType )
Application.addFunction( 'run' )
Application.addFunction( 'stop' )
Application.addConstructor( )
Application.addConstructor( 'applicationName' )

## graphics ##

## text ##

## ui ##

UI = Chisel.addNamespace( 'UI' )

Window = UI.addClass( 'Window', superclass=CObject )
Window.addProperty( 'title', StringType )
Window.addProperty( 'visible', BooleanType )
Window.addFunction( 'show' )
Window.addFunction( 'hide' )
Window.addFunction( 'close' )
Window.addFunction( 'willClose' )
Window.addConstructor( )
Window.addConstructor( 'title' )


View = UI.addClass( 'View', superclass=CObject )
#View.addFunction( 'addSubview', takes=[ (View, 'viewToAdd') ] )
View.addFunction( 'removeFromSuperview' )
View.addFunction( 'invalidate' )
Window.addProperty( 'contentView', View )

Chisel.generate( 'out' )
Chisel.generateHeader( '../native' )