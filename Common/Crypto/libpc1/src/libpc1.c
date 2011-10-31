/*	 
	PC1 Cipher Algorithm ( Pukall Cipher 1 ) 256 bits key.
	By Alexander PUKALL 1991 
	http://membres.multimania.fr/pc1/

	Free code no restriction to use 
	Please include the name of the Author in the final software.
		
	Written in Borland Turbo C 2.0 on PC
	Tested with Turbo C 2.0 for DOS and Microsoft Visual C++ 5.0 for Win32. 	
	
	Rewrite, optimization & Delphi 2007 Wrapper by [big_fury]SiZiOUS 2011.
	http://sbibuilder.shorturl.com/
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define KEY_SIZE 32

/* global variables */
//short c;	
unsigned short ax, bx, cx, dx, si, tmp, x1a2, x1a0[16], res, i, inter, cfc, cfd, compte;
unsigned char cle[KEY_SIZE];

/* Prototypes */
void fin(void);
int assemble(void);
int code(void);
void init_key(char*);
long pc1_init(int, int, long);

//------------------------------------------------------------------------------

void fin(void) {
	/* erase all variables */
	for (compte=0;compte<=31;compte++) {
		cle[compte]=0;
	}	
	ax=0;
	bx=0;
	cx=0;
	dx=0;
	si=0;
	tmp=0;
	x1a2=0;
	x1a0[0]=0;
	x1a0[1]=0;
	x1a0[2]=0;
	x1a0[3]=0;
	x1a0[4]=0;
	res=0;
	i=0;
	inter=0;
	cfc=0;
	cfd=0;
	compte=0;
//	c=0;
}

//------------------------------------------------------------------------------

int assemble(void) {
	x1a0[0]= ( cle[0]*256 )+ cle[1];
	code();
	inter=res;

	x1a0[1]= x1a0[0] ^ ( (cle[2]*256) + cle[3] );
	code();
	inter=inter^res;

	x1a0[2]= x1a0[1] ^ ( (cle[4]*256) + cle[5] );
	code();
	inter=inter^res;

	x1a0[3]= x1a0[2] ^ ( (cle[6]*256) + cle[7] );
	code();
	inter=inter^res;

	x1a0[4]= x1a0[3] ^ ( (cle[8]*256) + cle[9] );
	code();
	inter=inter^res;

	x1a0[5]= x1a0[4] ^ ( (cle[10]*256) + cle[11] );
	code();
	inter=inter^res;

	x1a0[6]= x1a0[5] ^ ( (cle[12]*256) + cle[13] );
	code();
	inter=inter^res;

	x1a0[7]= x1a0[6] ^ ( (cle[14]*256) + cle[15] );
	code();
	inter=inter^res;

	x1a0[8]= x1a0[7] ^ ( (cle[16]*256) + cle[17] );
	code();
	inter=inter^res;

	x1a0[9]= x1a0[8] ^ ( (cle[18]*256) + cle[19] );
	code();
	inter=inter^res;

	x1a0[10]= x1a0[9] ^ ( (cle[20]*256) + cle[21] );
	code();
	inter=inter^res;

	x1a0[11]= x1a0[10] ^ ( (cle[22]*256) + cle[23] );
	code();
	inter=inter^res;

	x1a0[12]= x1a0[11] ^ ( (cle[24]*256) + cle[25] );
	code();
	inter=inter^res;

	x1a0[13]= x1a0[12] ^ ( (cle[26]*256) + cle[27] );
	code();
	inter=inter^res;

	x1a0[14]= x1a0[13] ^ ( (cle[28]*256) + cle[29] );
	code();
	inter=inter^res;

	x1a0[15]= x1a0[14] ^ ( (cle[30]*256) + cle[31] );
	code();
	inter=inter^res;

	i=0;
	return(0);
}

//------------------------------------------------------------------------------

int code(void) {
	dx=x1a2+i;
	ax=x1a0[i];
	cx=0x015a;
	bx=0x4e35;

	tmp=ax;
	ax=si;
	si=tmp;

	tmp=ax;
	ax=dx;
	dx=tmp;

	if (ax!=0) {
		ax=ax*bx;
	}

	tmp=ax;
	ax=cx;
	cx=tmp;

	if (ax!=0) {
		ax=ax*si;
		cx=ax+cx;
	}

	tmp=ax;
	ax=si;
	si=tmp;
	ax=ax*bx;
	dx=cx+dx;

	ax=ax+1;

	x1a2=dx;
	x1a0[i]=ax;

	res=ax^dx;
	i=i+1;
	return(0);
}

//------------------------------------------------------------------------------

int c2i(char _c) {
	int _r = _c - 0x61;
	return _r;
}

//------------------------------------------------------------------------------

char i2c(int _i) {
	int _r = 0x61 + _i;
	return _r;
}

//------------------------------------------------------------------------------

// replacement for strlen()
int core_strlen(const char *s) {
	const char *p;
	for (p = s; *p; ++p);
	return p - s;
}

//------------------------------------------------------------------------------

void init_key(char* key) {
	int count, ki;
		
	count = core_strlen(key);
	if (count > KEY_SIZE) { 
		count = KEY_SIZE; 
	}
		
	// fill with the user key
	for(ki = 0; ki < count; ki++) {
		cle[ki] = key[ki];
	}
		
	// fill the rest with default password
	for(ki = count ; ki < KEY_SIZE; ki++) {
		cle[ki] = i2c(ki);
	}
//	printf("Password Zone = %s\n", cle);
	
	/* 	"abcdefghijklmnopqrstuvwxyz012345" is the default password used.
	If the user enter a key < 32 characters, characters of the default
	password will be used. */
}

//------------------------------------------------------------------------------

/*
	Mode: Encryption kind
	0 = classic (1 encrypted byte = 1 decrypted byte)
	else = letters_only (2 encrypted bytes = 1 decrypted byte)
*/

long pc1_init(int mode, int decrypt, long inbufsize) {		
	if (decrypt) {
		if (mode) { return inbufsize / 2; } else { return inbufsize; }
	} else {
		if (mode) { return inbufsize * 2; } else { return inbufsize; }
	}
}

//------------------------------------------------------------------------------

/*
	Main function
	Can encrypt/decrypt using PC1 algorithm.
	Mode is for the encryption/decryption kind (0 = classic, 1 = letters_only).
	Check the main() to see how it works (compile with -DMAIN flag).
*/
void pc1_cipher(int mode, int decrypt, char* key, char* inbuf, char* outbuf, long inbufsize) {
	int inindex, outindex;
	unsigned char c, d, e;
	
	si=0;
	x1a2=0;
	i=0;
	
	init_key(key);
		
	inindex = 0;
	outindex = 0;
	
	while(inindex < inbufsize) {
		/* c contains the byte read in the file */
		c = inbuf[inindex];
		
		if (decrypt && mode) {
			d = c2i(inbuf[inindex++]) << 4; // retrieve the 4 bits from the first letter 
			e = c2i(inbuf[inindex]); 		// retrieve the 4 bits from the second letter			
			c = d + e; 						// 4 bits of the first letter + 4 bits of the second = 8 bits
//			printf("  d=%d, e=%d, c=%d\n", d, e, c);
		}
				
		assemble();
		cfc = inter >> 8;
		cfd = inter & 255; /* cfc^cfd = random byte */
						
		/* K ZONE !!!!!!!!!!!!! */
		/* here the mix of c and cle[compte] is before the encryption/after the decryption of c */
		if (decrypt) {
			c = c ^ (cfc^cfd);
		}

		for (compte = 0; compte <= 31; compte++) {
			/* we mix the plaintext byte with the key */
			cle[compte] = cle[compte] ^ c;
		}

		if (!decrypt) {
			// do this for encrypting
			c = c ^ (cfc ^ cfd);						
		}
		
		if (!decrypt && mode) {
			/* we split the 'c' crypted byte into two 4 bits parts 'd' and 'e' */
			d = c >> 4;
			e = c & 15;
//			printf("  d=%d, e=%d, c=%d\n", d, e, c);			
			/* we write the two 4 bits parts as ASCII letters */
			outbuf[outindex++] = i2c(d);
			outbuf[outindex] = i2c(e);
		} else {
			outbuf[outindex] = c;	
		}
						
		inindex++;
		outindex++;
	} // while
	
	fin();
}

//------------------------------------------------------------------------------

#ifdef MAIN

int main(int argc, char* argv[]) {
	char key[KEY_SIZE];
	int decrypt, mode;	
	FILE *in, *out;
	char *inbuf, *outbuf;
	long insize, outsize, result;
	char *string;
	
	printf("PC1 Cipher Algorithm ( Pukall Cipher 1 ) 256 bits\n");
	printf("By Alexander PUKALL 1991\n");
	printf("Rewrite, optimization, Delphi Wrapper by [big_fury]SiZiOUS 2011.\n\n");
	
	if (argc < 6) {
		printf("usage: libpc1 <in.bin> <out.bin> <mode> <decrypt> <key>\n\n");
		fin();
		return 1;
	}
	
	/* IN.BIN is the source file */		
	if ((in = fopen(argv[1], "rb")) == NULL) {
		printf("\nError reading file IN.BIN !\n");
		fin();
		return 2;
	}
	printf("Input File.......: %s\n", argv[1]);
	
	/* OUT.BIN is the destination file */
	if ((out = fopen(argv[2], "wb")) == NULL) {
		printf("\nError writing file OUT.BIN !\n");
		fin();
		return 3;
	}
	printf("Output File......: %s\n", argv[2]);
	
	/* Mode Classic = 0 (Binary), Mode Advanced = 1 (text letters only) */
	mode = 1;
	string = "Advanced";
	if (!strcmp(argv[3], "0")) { mode = 0; string = "Classic"; }
	printf("Mode.............: %s\n", string);
	
	/* Encrypt = 0, Decrypt = 1 */
	decrypt = 1;
	string = "Decrypt";
	if (!strcmp(argv[4], "0")) { decrypt = 0; string = "Encrypt"; }
	printf("Decrypt..........: %s\n", string);
	
	/* Key */
	strncpy(key, argv[5], KEY_SIZE);
	printf("Key..............: %s\n\n", key);
	
	/* GO ! */
	
	/* Retrieve the IN.BIN size */
	fseek (in, 0, SEEK_END);
	insize = ftell (in);
	rewind (in);
	
	// allocate memory to contain the whole IN.BIN file
	inbuf = (char*) malloc (sizeof(char) * insize);
	if (inbuf == NULL) {
		fputs ("Memory error", stderr); 
		fin();
		return 4;
	}

	// copy the IN.BIN file into the buffer
	result = fread (inbuf, 1, insize, in);
	if (result != insize) {
		fputs ("Reading error", stderr); 
		fin();
		return 5;
	}
		
	/* the whole file is now loaded in the memory buffer. */
	
	/* Init PC1 encryption */
	outsize = pc1_init(mode, decrypt, insize);
	
	/* Allocate the out buffer */
	outbuf = (char*) malloc (sizeof(char) * outsize);
	
	/* Do the job */
	pc1_cipher(mode, decrypt, key, inbuf, outbuf, insize);
	
	/* Writing result to OUT.BIN */
	fwrite(outbuf, 1, outsize, out);
	
	/* Cleaning all */
	free(inbuf);
	fclose (in);
	
	free(outbuf);	
	fclose (out);
	
	fin();	
	
	printf("Done !\n\n");
	
	return 0;
}

#endif

//------------------------------------------------------------------------------

