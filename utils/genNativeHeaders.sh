GEN="python utils/genNativeH.py"

$GEN chisel/core/application.d chisel/core/native/chisel-native-application.h
$GEN chisel/core/exceptions.d chisel/core/native/chisel-native-exceptions.h
$GEN chisel/core/string.d chisel/core/native/chisel-native-string.h

$GEN chisel/graphics/context.d chisel/graphics/native/chisel-native-context.h

$GEN chisel/text/font.d chisel/text/native/chisel-native-font.h
$GEN chisel/text/formattedstring.d chisel/text/native/chisel-native-formattedstring.h

$GEN chisel/ui/view.d chisel/ui/native/chisel-native-view.h
$GEN chisel/ui/window.d chisel/ui/native/chisel-native-window.h
$GEN chisel/ui/openglcontext.d chisel/ui/native/chisel-native-openglcontext.h
$GEN chisel/ui/openglview.d chisel/ui/native/chisel-native-openglview.h