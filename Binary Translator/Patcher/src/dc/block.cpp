
#include <string>

#include "block.h"

uint32_t Block :: getAddr() {
    return addr;
}


uint32_t Block :: getSize() {
    return size;
}


bool Block :: fit(std::string str) {
    return str.size() < size;
}


bool Block :: update(std::string str) {
    if (fit(str)) {
        addr += str.size() +1;  // don't forget the '\0'
        return true;
    }
    return false;
}


bool Block :: operator<(const Block &i) const {
    return size < i.size;
}


Block :: Block(uint32_t _addr, uint32_t _size) {
    addr = _addr;
    size = _size;
}

Block :: ~Block() {
}
