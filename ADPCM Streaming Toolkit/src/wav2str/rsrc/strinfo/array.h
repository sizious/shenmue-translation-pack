#ifndef __ARRAY__H__
#define __ARRAY__H__

#include <stdio.h>
#include <string.h>

void memcpy_array(char* src_array, void* dest, int start, int length);
void print_hexarray(char* a, int length);
int get_array_int(char* src_array, int start);
short get_array_short(char* src_array, int start);

#endif // __ARRAY__H__
