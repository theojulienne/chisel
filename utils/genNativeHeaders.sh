GEN="python utils/genNativeH.py"

$GEN chisel/core/application.d chisel/core/native/chisel-native-application.h
$GEN chisel/core/exceptions.d chisel/core/native/chisel-native-exceptions.h
$GEN chisel/core/string.d chisel/core/native/chisel-native-string.h
$GEN chisel/core/array.d chisel/core/native/chisel-native-array.h
$GEN chisel/core/number.d chisel/core/native/chisel-native-number.h
$GEN chisel/core/native.d chisel/core/native/chisel-native-bridge.h
$GEN chisel/core/wrapped.d chisel/core/native/chisel-native-wrapped.h

$GEN chisel/graphics/context.d chisel/graphics/native/chisel-native-context.h
$GEN chisel/graphics/image.d chisel/graphics/native/chisel-native-image.h

$GEN chisel/text/font.d chisel/text/native/chisel-native-font.h
$GEN chisel/text/formattedstring.d chisel/text/native/chisel-native-formattedstring.h

$GEN chisel/ui/view.d chisel/ui/native/chisel-native-view.h
$GEN chisel/ui/window.d chisel/ui/native/chisel-native-window.h
$GEN chisel/ui/openglcontext.d chisel/ui/native/chisel-native-openglcontext.h
# views
$GEN chisel/ui/openglview.d chisel/ui/native/chisel-native-openglview.h
$GEN chisel/ui/splitview.d chisel/ui/native/chisel-native-splitview.h
$GEN chisel/ui/frame.d chisel/ui/native/chisel-native-frame.h
$GEN chisel/ui/tabview.d chisel/ui/native/chisel-native-tabview.h
$GEN chisel/ui/tabviewitem.d chisel/ui/native/chisel-native-tabviewitem.h
# controls
$GEN chisel/ui/slider.d chisel/ui/native/chisel-native-slider.h
$GEN chisel/ui/label.d chisel/ui/native/chisel-native-label.h
$GEN chisel/ui/button.d chisel/ui/native/chisel-native-button.h
$GEN chisel/ui/progressbar.d chisel/ui/native/chisel-native-progressbar.h
$GEN chisel/ui/checkbox.d chisel/ui/native/chisel-native-checkbox.h
# treeview
$GEN chisel/ui/tablecolumn.d chisel/ui/native/chisel-native-tablecolumn.h
$GEN chisel/ui/treeview.d chisel/ui/native/chisel-native-treeview.h
# menuing
$GEN chisel/ui/menu.d chisel/ui/native/chisel-native-menu.h
$GEN chisel/ui/menuitem.d chisel/ui/native/chisel-native-menuitem.h
$GEN chisel/ui/menubar.d chisel/ui/native/chisel-native-menubar.h
$GEN chisel/ui/contextmenu.d chisel/ui/native/chisel-native-contextmenu.h
# choosers
$GEN chisel/ui/fileopenchooser.d chisel/ui/native/chisel-native-fileopenchooser.h
$GEN chisel/ui/filesavechooser.d chisel/ui/native/chisel-native-filesavechooser.h