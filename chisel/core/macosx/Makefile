OBJS=application.o exceptions.o string.o
TARGET=libchiselnative-core.a
CFLAGS=-m32 -g -Wall -I../native/

all: $(TARGET)

$(TARGET): $(OBJS)
	ar rcs $(TARGET) $(OBJS)
	ranlib $(TARGET)

clean:
	rm -rf $(OBJS) $(TARGET)