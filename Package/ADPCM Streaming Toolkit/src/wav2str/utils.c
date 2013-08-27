#include "utils.h"

void write_null_block(FILE *target, int size) {
	unsigned char* buf;
	
	buf = (char *) malloc(size);
	memset(buf, 0x0, size);
	fwrite(buf, 1, size, target);
	free(buf);
}

char* extract_filename(char *filename) {
	char *p, *result;
	int i, j, lgth;
	
	int cpystart = 0;
	int cpyend = strlen(filename);
	
	// le dernier slash séparateur, le nom est entre les deux
	if((p = strrchr(filename, '\\')) != NULL) {
		cpystart = (p - filename) + 1;
	}
	
	// allocating new proggyname
	lgth = (cpyend - cpystart);
	result = (char*) malloc(lgth + 1); // + 1 pour \0
	for(i = cpystart, j = 0 ; i < cpyend ; i++, j++)
		result[j] = filename[i];
	result[lgth] = '\0';
			
	// l'extension est présente
	if((p = strrchr(filename, '.')) != NULL) {
		cpystart = (strlen(filename) - strlen(p)) - cpystart;
		result[cpystart] = '\0';
	}
					
	return result;
}

char* change_fileext(char *filename, char* ext) {
	char* tmp = extract_filename(filename);
	char* result = strcat(tmp, ext);
	return result;
}
