#ifndef __PATCH_H
#define __PATCH_H

#include "liblzma/7z.h"

#include <windows.h> 
#include <stdio.h>
#include <tchar.h>

#include <stddef.h>

#define BUFSIZE MAX_PATH

// Error codes
#define SZ_PATCH_BASE_CODE 10000
#define SZ_PATCH_RESTORE_CURRENT_PATH_ERROR SZ_PATCH_BASE_CODE + 1
#define SZ_PATCH_CURRENT_PATH_NOT_SAVED SZ_PATCH_BASE_CODE + 2
#define SZ_PATCH_PATH_BUFFER_TOO_SHORT SZ_PATCH_BASE_CODE + 3
#define SZ_PATCH_OUTPUT_PATH_DOESNT_EXISTS SZ_PATCH_BASE_CODE + 4

#ifdef __cplusplus
extern "C" {
#endif

int changeCurrentPath(TCHAR*);
int restoreCurrentPath();

#ifdef __cplusplus
}
#endif

#endif // __PATCH_H
