/*
    aica adpcm <-> wave converter;

    (c) 2002 BERO <bero@geocities.co.jp>
    under GPL or notify me

    aica adpcm seems same as YMZ280B adpcm
    adpcm->pcm algorithm can found MAME/src/sound/ymz280b.c by Aaron Giles

    this code is for little endian machine

    Modified by Dan Potter to read/write ADPCM WAV files, and to
    handle stereo (though the stereo is very likely KOS specific
    since we make no effort to interleave it). Please see README.GPL
    in the KOS docs dir for more info on the GPL license.
	
    Modified by [big_fury]SiZiOUS to encode WAV to Yamaha AICA Stream files used by Shenmue series.
*/

#include <stdio.h>
#include <stdlib.h>

static int diff_lookup[16] = {
    1,3,5,7,9,11,13,15,
    -1,-3,-5,-7,-9,-11,-13,-15,
};

static int index_scale[16] = {
    0x0e6, 0x0e6, 0x0e6, 0x0e6, 0x133, 0x199, 0x200, 0x266,
    0x0e6, 0x0e6, 0x0e6, 0x0e6, 0x133, 0x199, 0x200, 0x266 //same value for speedup
};

static inline int limit(int val,int min,int max)
{
    if (val<min) return min;
    else if (val>max) return max;
    else return val;
}

void pcm2adpcm(unsigned char *dst,const short *src,size_t length)
{
    int signal,step;
    signal = 0;
    step = 0x7f;

    // length/=4;
    length = (length+3)/4;
    do {
        int data,val,diff;

        /* hign nibble */
        diff = *src++ - signal;
        diff = (diff*8)/step;

        val = abs(diff)/2;
        if (val>7) val = 7;
        if (diff<0) val+=8;

        signal += (step*diff_lookup[val])/8;
        signal = limit(signal,-32768,32767);

        step = (step * index_scale[val]) >> 8;
        step = limit(step,0x7f,0x6000);

        data = val;

        /* low nibble */
        diff = *src++ - signal;
        diff = (diff*8)/step;

        val = (abs(diff))/2;
        if (val>7) val = 7;
        if (diff<0) val+=8;

        signal += (step*diff_lookup[val])/8;
        signal = limit(signal,-32768,32767);

        step = (step * index_scale[val]) >> 8;
        step = limit(step,0x7f,0x6000);

        data |= val << 4;

        *dst++ = data;

    } while(--length);
}

/*
void adpcm2pcm(short *dst,const unsigned char *src,size_t length)
{
    int signal,step;
    signal = 0;
    step = 0x7f;

    do {
        int data,val;

        data = *src++;

        // low nibble
        val = data & 15;

        signal += (step*diff_lookup[val])/8;
        signal = limit(signal,-32768,32767);

        step = (step * index_scale[val & 7]) >> 8;
        step = limit(step,0x7f,0x6000);

        *dst++= signal;

        // high nibble
        val = (data >> 4)&15;

        signal += (step*diff_lookup[val])/8;
        signal = limit(signal,-32768,32767);

        step = (step * index_scale[val & 7]) >> 8;
        step = limit(step,0x7f,0x6000);

        *dst++ = signal;

    } while(--length);
}
*/

/*
void deinterleave(void *buffer, size_t size) {
    short * buf;
    short * buf1, * buf2;
    int i;

    buf = (short *)buffer;
    buf1 = malloc(size / 2);
    buf2 = malloc(size / 2);

    for (i=0; i<size/4; i++) {
        buf1[i] = buf[i*2+0];
        buf2[i] = buf[i*2+1];
    }

    memcpy(buf, buf1, size/2);
    memcpy(buf + size/4, buf2, size/2);

    free(buf1);
    free(buf2);
}

void interleave(void *buffer, size_t size) {
    short * buf;
    short * buf1, * buf2;
    int i;

    buf = malloc(size);
    buf1 = (short *)buffer;
    buf2 = buf1 + size/4;

    for (i=0; i<size/4; i++) {
        buf[i*2+0] = buf1[i];
        buf[i*2+1] = buf2[i];
    }

    memcpy(buffer, buf, size);

    free(buf);
}
*/

struct wavhdr_t {
    char hdr1[4];
    long totalsize;

    char hdr2[8];
    long hdrsize;
    short format;
    short channels;
    long freq;
    long byte_per_sec;
    short blocksize;
    short bits;

    char hdr3[4];
    long datasize;
};

typedef struct _naomispsd {
	char sign[4];		// "SPSD"
	int dontcare; 		// don't know...
	int foo;			// don't know...
	int datasize;		// ADPCM data size
	/*int crap;			// don't know...
	int crap_again; 	// don't know...
	int crappy_crap;	// don't know...
	int holy_shit;		// don't know...
	int crappy_shit;	// don't know...
	int oioioi;			// don't know...
	short null;			// don't know...*/
	long frequency;		// Frequency
	int wtf;
	short foobar;		// don't know...
	char nulldata[10];	// don't know...
} naomispsd_t;

int wav2adpcm(const char *infile,const char *outfile)
{
    struct wavhdr_t wavhdr;
    FILE *in,*out;
    size_t pcmsize,adpcmsize;
    short *pcmbuf;
    unsigned char *adpcmbuf;	
	naomispsd_t spsdhdr;

    in = fopen(infile,"rb");
    if (in==NULL)  {
        printf("can't open %s\n",infile);
        return -1;
    }
    fread(&wavhdr,1,sizeof(wavhdr),in);

    if(memcmp(wavhdr.hdr1,"RIFF",4)
    || memcmp(wavhdr.hdr2,"WAVEfmt ",8)
    || memcmp(wavhdr.hdr3,"data",4)
    || wavhdr.hdrsize!=0x10
    || wavhdr.format!=1
    || (wavhdr.channels!=1)
    || wavhdr.bits!=16) {
        printf("Unsupported format. Input files must be mono with 16 bits PCM data.\n");
        fclose(in);
        return -1;
    }

    pcmsize = wavhdr.datasize;

    adpcmsize = pcmsize/4;
    pcmbuf = malloc(pcmsize);
    adpcmbuf = malloc(adpcmsize);

    fread(pcmbuf,1,pcmsize,in);
    fclose(in);
	
	pcm2adpcm(adpcmbuf, pcmbuf, pcmsize);

    out = fopen(outfile,"wb");
	if (out != NULL) {
	
	    wavhdr.datasize = adpcmsize;
	    wavhdr.format = 20;    /* ITU G.723 ADPCM (Yamaha) */
	    wavhdr.bits = 4;
	    wavhdr.totalsize = wavhdr.datasize + sizeof(wavhdr)-8;
	    		
		// init spsd header
		strcpy(spsdhdr.sign, "SPSD");
		spsdhdr.dontcare = 0x4000101;
		spsdhdr.foo = 0x03;
		spsdhdr.datasize = adpcmsize;
///		spsdhdr.crap = 0x1FF71FF7;
//		spsdhdr.crap_again = 0x1FF71FF7;
//		spsdhdr.crappy_crap = 0x1FF7;
		/*spsdhdr.holy_shit = 0x1040000;
		spsdhdr.crappy_shit = 0x71140000;
		spsdhdr.oioioi = 0x1F001F;
		spsdhdr.null = 0xaaaa; //0x0000BC00;
		spsdhdr.frequency = wavhdr.freq;				
		spsdhdr.wtf = 0xeeeeeeee;
		spsdhdr.foobar = 0x0;
		memset(spsdhdr.nulldata, 0x0, sizeof(spsdhdr.nulldata));*/
		
		printf("Data size: %d byte(s)\n", spsdhdr.datasize);
		//printf("Frequency: %d Hz\n", spsdhdr.frequency);
		
		// fwrite(&spsdhdr.frequency, 1, sizeof(long), out);
		
		// write SPSD header
		fwrite(&spsdhdr, 1, sizeof(spsdhdr), out);

		// write ADPCM data
//		fwrite(adpcmbuf, 1, adpcmsize, out);
	   
		fclose(out);
		
	} else {
		printf("Failed to write to output file...");
		return -1;
	}

    return 0;
}

void print_header() {
    printf(
		"WAV2STR - Waveform to Shenmue Yamaha AICA ADPCM Stream Encoder\n"
		"Based on wav2adpcm converter (c)2002 by BERO\n"
		"Version 0.1 (%s) - (C)reated by [big_fury]SiZiOUS\n\n", __DATE__
	);
}

void print_usage() {
	printf(
		"usage"
		"\n\n"
	);
}

int main(int argc, char *argv[]) {
	int result = -1;
	
	print_header();
	
	if (argc < 2) {
		print_usage();
	} else {
		result = wav2adpcm(argv[1], argv[2]);
	}
	
	return result;
}

