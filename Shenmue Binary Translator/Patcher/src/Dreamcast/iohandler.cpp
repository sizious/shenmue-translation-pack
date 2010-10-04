
#include <string>

#include <stdio.h>
#include "iohandler.h"


void IOHandler :: writeInt(uint32_t addr, uint32_t value) {
    value += 0x8c010000;

    fseek(fichier, addr, SEEK_SET);
    fwrite(&value, sizeof(uint32_t), 1, fichier);
}


void IOHandler :: writeString(uint32_t addr, std::string text) {
    fseek(fichier, addr, SEEK_SET);

    const char *str = text.c_str();
    fwrite(str, 1, text.size()+1, fichier);
}


IOHandler :: IOHandler(std::string filename, uint32_t _addrBase) {
    fichier = fopen(filename.c_str(), "rb+");
    addrBase = _addrBase;
}

IOHandler :: ~IOHandler() {
    fclose(fichier);
}
