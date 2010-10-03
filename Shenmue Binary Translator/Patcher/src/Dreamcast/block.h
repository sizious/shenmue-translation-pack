
#ifndef BLOCK_H
#define BLOCK_H

#include <stdint.h>

class Block {
    private:
        uint32_t addr;
        uint32_t size;
    public:
        uint32_t getAddr();
        uint32_t getSize();
        bool fit(std::string str);
        bool update(std::string str);

        Block(uint32_t addr, uint32_t size);
        ~Block();

        bool operator<(const Block &i) const;
};

#endif
