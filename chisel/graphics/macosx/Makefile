OBJS=image.o context.o helpers.o
TARGET=libchiselnative-graphics.a
CFLAGS=-m32 -g -Wall -I../../core/macosx/ -I../../core/native/ -I../native/

all: $(TARGET)

$(TARGET): $(OBJS)
	ar rcs $(TARGET) $(OBJS)
	ranlib $(TARGET)

clean:
	rm -rf $(OBJS) $(TARGET)
