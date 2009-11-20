OBJS=menubar.o contextmenu.o checkbox.o menuitem.o window.o view.o openglview.o openglcontext.o slider.o splitview.o label.o frame.o button.o menu.o progressbar.o treeview.o tablecolumn.o
TARGET=libchiselnative-ui.a
CFLAGS=-m32 -g -Wall -I../../core/macosx/ -I../../core/native/ -I../../graphics/native/ -I../native/

all: $(TARGET)

$(TARGET): $(OBJS)
	ar rcs $(TARGET) $(OBJS)
	ranlib $(TARGET)

clean:
	rm -rf $(OBJS) $(TARGET)
