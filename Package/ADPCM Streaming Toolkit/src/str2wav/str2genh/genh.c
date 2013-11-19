#include "genh.h"

void write_genh_header(FILE *outfile, int frequency, int sound_length) {
	genh_struct genh;
	
	// writing genh header to output file
	char *p = strcpy(genh.magic_word, "GENH");
	genh.channels = 1;
	genh.interleave = 0;
	genh.frequency = frequency;
	genh.loop_start = 0xFFFFFFFF;
	genh.loop_end = (sound_length * 2);
	genh.identifer = 0x0A; // Yamaha AICA 4-bit ADPCM
	genh.audio_start_offset = 0x1040;
	genh.genh_length = 0x1000;
	fwrite(&genh, 1, sizeof(genh), outfile);	
	if (p != NULL) free(p);
	write_null_block(outfile, 4060);
}

int make_genh(FILE *infile, FILE *outfile) {
	int bytes_read, frequency, sound_length;
	char *buffer;
	
	if (!check_stream_file_sign(infile)) {
		printf("Not a valid Shenmue STR file format\n");
		return 0;
	}
	
	// reading values from NAOMI SPSD header
	fseek(infile, 0x2A, SEEK_SET);
	fread(&frequency, 1, sizeof(int), infile);
	printf("Sample rate: %d Hz\n", frequency);
	
	fseek(infile, 0x0C, SEEK_SET);
	fread(&sound_length, 1, sizeof(int), infile);
	printf("Stream length: %d (%.2lf seconds)\n", sound_length, (double) sound_length / frequency);
	
	// writing header
	write_genh_header(outfile, frequency, sound_length);
	
	// writing original file to genh
	buffer = (char*) malloc (BUFFER_SIZE);	
	fseek(infile, 0x0, SEEK_SET);
	while ((bytes_read = fread(buffer, 1, BUFFER_SIZE, infile)) > 0) {
		fwrite(buffer, 1, bytes_read, outfile);
	}
	free(buffer);
	
	return 1;
}

int check_stream_file_sign(FILE *infile) {
	char sign[5];
	int pos = ftell(infile);
	
	fseek(infile, 0x0, SEEK_SET);
	fread(sign, 1, sizeof(sign), infile);
	fseek(infile, pos, SEEK_SET);	
	sign[4] = '\0';
		
	return (strcmp(sign, NAOMI_SPSD_SIGN) == 0);
}
