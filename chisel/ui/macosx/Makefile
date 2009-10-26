OBJS=window.o view.o openglview.o openglcontext.o
TARGET=libchiselnative-ui.a
CFLAGS=-g -Wall -I../../core/macosx/ -I../../core/native/ -I../../graphics/native/ -I../native/

all: $(TARGET)

$(TARGET): $(OBJS)
	ar rcs $(TARGET) $(OBJS)
	ranlib $(TARGET)

clean:
	rm -rf $(OBJS) $(TARGET)