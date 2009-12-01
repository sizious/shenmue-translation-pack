# proggys
CC = gcc
AR = ar
RM = rm
STRIP = strip
WINDRES = windres
# PACKER = upx

# flags
CFLAGS = -O3
# PACKEROPT = -9

# files
BIN = str2genh
TARGET = bin/$(BIN)$(OS:Windows_NT=.exe)
LIBS = 

OBJSDIR = obj/
OBJS = $(OBJSDIR)utils.o $(OBJSDIR)genh.o $(OS:Windows_NT=$(OBJSDIR)rsrc.o) $(OBJSDIR)main.o

# go !	
all : $(OBJS)
	$(CC) -o $(TARGET) $(OBJS) $(CFLAGS) $(LIBS)
	$(STRIP) $(TARGET)
#	$(PACKER) $(PACKEROPT) $(TARGET)
	
# compile source
$(OBJSDIR)%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# include win32 resources
$(OBJSDIR)rsrc.o: rsrc.rc
	$(WINDRES) -i rsrc.rc -o $(OBJSDIR)rsrc.o
	
clean:
	$(RM) $(OBJS)
	
clean-all:
	$(RM) $(OBJS) $(TARGET)