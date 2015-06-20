#include "genh.h"
#include "utils.h"
#include <stdio.h>
#include <stdlib.h>

void print_banner() {
	printf("Shenmue Yamaha AICA ADPCM Stream to Generic Header converter\n");
	printf("Version 0.1 (%s) - (C)reated by [big_fury]SiZiOUS\n", __DATE__);
	printf("http://sbibuilder.shorturl.com/\n\n");
}

void print_usage(char* prgname) {
	printf("Usage: %s <infile.str> [outfile.genh]\n", prgname);
}

int main(int argc, char* argv[]) {
	FILE *infile;
	FILE *outfile;
	char* proggy_name;
	char* output_filename;

	// init screen
	print_banner();
	
	if (argc < 2) {
		proggy_name = extract_filename(argv[0]);
		print_usage(proggy_name);
		free(proggy_name);
		return 1;
	}
		
	if (argc == 2) {
		output_filename = change_fileext(argv[1], ".genh");
	} else {
		output_filename = strdup(argv[2]);
	}
	
	infile = fopen(argv[1], "rb");
	
	if (infile != NULL) {
		printf("Input file: %s\n", argv[1]);
		printf("Output file: %s\n", output_filename);
		outfile = fopen(output_filename, "wb");
			
		if (outfile != NULL) {
			make_genh(infile, outfile);
			fclose(outfile);
		}
		
		free(output_filename);
		fclose(infile);
	
	} else {
		printf("Input file not found: %s\n", argv[1]);
	}
		
	return 0;
}
