
#ifndef MEMORYMANAGER_H
#define MEMORYMANAGER_H

#include "block.h"
#include "iohandler.h"
#include "insert.h"


class MemoryManager {
    private:
        std::vector<Block*> blocks;
        IOHandler *handler;

    public:
        bool insertStrings(std::vector<Insert*> inserts);
        void insertNewBlock(uint32_t addr, uint32_t size);

        MemoryManager(IOHandler *handler);
        ~MemoryManager();
};

#endif
