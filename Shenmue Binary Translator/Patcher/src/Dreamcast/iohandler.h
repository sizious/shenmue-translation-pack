
#ifndef IOHANDLER_H
#define IOHANDLER_H

#include <stdint.h>

class IOHandler {
    private:
        FILE *fichier;
        uint32_t addrBase;

    public:
        bool writeInt(uint32_t addr, uint32_t value);
        bool writeString(uint32_t addr, std::string text);

        IOHandler(std::string filename, uint32_t addrBase);
        ~IOHandler();
};

#endif
