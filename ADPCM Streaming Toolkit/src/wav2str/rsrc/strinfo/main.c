#include "array.h"
#include <stdio.h>

unsigned int filesize(FILE *f) {
	fseek (f , 0 , SEEK_END);
	int size = ftell (f);
	rewind (f);
	return size;
}

int dumpstr(const char *infile) {
    FILE *in;
	char hdrbuf[64];
	char sign[5];
	void* p;
	
	int datasize, unknow;
	unsigned int fsize;
	short id;
	
	in = fopen(infile, "rb");
	if (in != NULL) {
	
	    fread(hdrbuf, 1, sizeof(hdrbuf), in);	
		memcpy(sign, hdrbuf, 4);
		sign[4] = '\0';
		
		if (!strcmp(sign, "SPSD") == 0) {
			printf("%s: Not a valid NAOMI SPSD file.\n", infile);
			return -1;
		}
		
		datasize = get_array_int(hdrbuf, 12);
		id = get_array_short(hdrbuf, 46);
		unknow = get_array_int(hdrbuf, 50);
		fsize = filesize(in);
		
		printf("%s;%d;%d;%d;%d;", infile, fsize, datasize, id, unknow);
		
		print_hexarray(hdrbuf, 64);
		printf("\n");
		
	    fclose(in);
	}
	

    return 0;
}

int main(int argc, char *argv[]) {
	int result = -1;
	
	if (argc == 2) {
		result = dumpstr(argv[1]);
	}
	
	return result;
}

