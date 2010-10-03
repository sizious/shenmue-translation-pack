
#include <string>

#include <stdio.h>
#include "iohandler.h"


bool IOHandler :: writeInt(uint32_t addr, uint32_t value) {
    fseek(fichier, addr, SEEK_SET);
    fwrite(&value, sizeof(uint32_t), 1, fichier);
}


bool IOHandler :: writeString(uint32_t addr, std::string text) {
    fseek(fichier, addr, SEEK_SET);

    const char *str = text.c_str();
    fwrite(str, 1, text.size()+1, fichier);
}


IOHandler :: IOHandler(std::string filename, uint32_t _addrBase) {
    fichier = fopen(filename.c_str(), "wb");
    addrBase = _addrBase;
}

IOHandler :: ~IOHandler() {
    fclose(fichier);
}
