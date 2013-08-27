#ifndef __GENH__H__
#define __GENH__H__

#include <stdio.h>
#include "utils.h"

#define NAOMI_SPSD_SIGN "SPSD"

typedef struct {
	char magic_word[4];
	int channels;
	int interleave;
	int frequency;
	int loop_start;
	int loop_end;
	int identifer;
	int audio_start_offset;
	int genh_length;
} genh_struct;

int check_stream_file_sign(FILE *infile);
int make_genh(FILE *infile, FILE *outfile);

#endif // __GENH__H__
