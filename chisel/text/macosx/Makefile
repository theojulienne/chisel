OBJS=font.o formattedstring.o helpers.o
TARGET=libchiselnative-text.a
CFLAGS=-m32 -g -Wall -I../../core/macosx/ -I../../core/native/ -I../../graphics/native/ -I../native/

all: $(TARGET)

$(TARGET): $(OBJS)
	ar rcs $(TARGET) $(OBJS)
	ranlib $(TARGET)

clean:
	rm -rf $(OBJS) $(TARGET)