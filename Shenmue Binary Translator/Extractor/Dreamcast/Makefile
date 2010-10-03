
CC=gcc
TARGET=dc_strings_extractor

OBJS=dreamcast.o


all: $(OBJS)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $(TARGET)

clean:
	-rm -rf $(OBJS) $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<
