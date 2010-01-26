#include "patch.h"

TCHAR currentPathBuffer[BUFSIZE];
   
int changeCurrentPath(TCHAR* targetDirectory) { 
   DWORD dwRet;
   
   dwRet = GetCurrentDirectory(BUFSIZE, currentPathBuffer);

   if(dwRet == 0) {
      return SZ_PATCH_CURRENT_PATH_NOT_SAVED;
   }
   
   if(dwRet > BUFSIZE) {
#ifdef DEBUG
      fprintf(stderr, "Buffer too short, need %d more buffer chars !\n", dwRet);
#endif
      return SZ_PATCH_PATH_BUFFER_TOO_SHORT;
   }

   if(!SetCurrentDirectory(targetDirectory)) {
      return SZ_PATCH_OUTPUT_PATH_DOESNT_EXISTS;
   }
   
#ifdef DEBUG
   _tprintf(TEXT("Set current directory to %s\n"), targetDirectory);
#endif
   
   return SZ_OK;
}

int restoreCurrentPath() {
	if(!SetCurrentDirectory(currentPathBuffer)) {
		return 0;
	}
	
#ifdef DEBUG
	_tprintf(TEXT("Restored previous directory (%s)\n"), currentPathBuffer);
#endif

	return 1;
}
