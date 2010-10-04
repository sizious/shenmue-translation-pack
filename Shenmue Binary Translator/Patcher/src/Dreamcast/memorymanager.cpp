
#include <string>
#include <vector>
#include <algorithm>

#include "memorymanager.h"

#include <stdio.h>


static bool cmpInserts(Insert *a, Insert *b) {
    return *a < *b;
}


static bool cmpBlocks(Block *a, Block *b) {
    return *a < *b;
}


void MemoryManager :: insertNewBlock(uint32_t addr, uint32_t size) {
    blocks.push_back(new Block(addr, size));
}


bool MemoryManager :: insertStrings(std::vector<Insert*> inserts) {
    Insert *insert;
    Block *block;
    unsigned int i;

    std::sort(inserts.begin(), inserts.end(), cmpInserts);

    while(!inserts.empty()) {
        std::sort(blocks.begin(), blocks.end(), cmpBlocks);

        insert = inserts[inserts.size()-1];
        inserts.pop_back();

        block = blocks[blocks.size()-1];
        blocks.pop_back();

        if (!block->fit(insert->getText()))
          return false;

        printf("Inserting string \"%s\" to address 0x%x.\n", insert->getText().c_str(), block->getAddr());
        handler->writeString(block->getAddr(), insert->getText());

        for (i=0; i<insert->getPtrs().size(); i++)
            handler->writeInt(insert->getPtrs()[i]->getAddr(), block->getAddr());

        block->update(insert->getText());

        blocks.push_back(block);
    }

    return true;
}


MemoryManager :: MemoryManager(IOHandler *_handler) {
    handler = _handler;
}


MemoryManager :: ~MemoryManager() {
    unsigned int i;
    for (i=0; i<blocks.size(); i++)
      delete blocks[i];
}
