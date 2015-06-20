#ifndef __UTILS__H__
#define __UTILS__H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 1024

void write_null_block(FILE *target, int size);
char* extract_filename(char *filename);
char* change_fileext(char *filename, char* ext);

#endif // __UTILS__H__
