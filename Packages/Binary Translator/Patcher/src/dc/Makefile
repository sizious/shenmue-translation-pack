
CPP=g++
TARGET=dc_patcher
XMLINC=-I/usr/include/libxml2
LIBS=-lxml2

OBJS=main.o block.o iohandler.o memorymanager.o insert.o ptr.o xmlfilereader.o


all: $(OBJS)
	$(CPP) $(CFLAGS) $^ $(LDFLAGS) $(LIBS) -o $(TARGET)

release: all
	objcopy -S $(TARGET)

clean:
	-rm -rf $(OBJS) $(TARGET)

%.o: %.cpp
	$(CPP) $(CFLAGS) $(XMLINC) -o $@ -c $<
