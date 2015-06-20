#include "array.h"

// pareil que memcpy mais avec un décalage de start
void memcpy_array(char* src_array, void* dest, int start, int length) {
	int i, j;
	char* p;
	
	// création d'un nouveau tableau de char
	p = calloc(length, 1);
	for(i = start, j = 0; j < length ; i++, j++) {
		p[j] = src_array[i]; // décalage à partir de start
	}
			
	// affectation au résultat
	memcpy(dest, p, length);
		
	// destruction du tableau temporaire
	free(p);
}

void print_hexarray(char* a, int length) {
	int i;
	for (i = 0 ; i < length ; i++) {
		printf("%2.2x", (unsigned char) a[i]);
	}
}

int get_array_int(char* src_array, int start) {
	int buf;	
	memcpy_array(src_array, &buf, start, sizeof(int));	
	// printf("%d\n", buf);
	return buf;
}

short get_array_short(char* src_array, int start) {
	short buf;	
	memcpy_array(src_array, &buf, start, sizeof(short));	
	// printf("%d\n", buf);
	return buf;
}
