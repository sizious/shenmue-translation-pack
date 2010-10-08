
#include "ptr.h"

uint32_t Ptr :: getAddr() {
    return addr;
}

void Ptr :: setAddr(uint32_t _addr) {
    addr = _addr;
}

Ptr :: Ptr(uint32_t _addr) {
    setAddr(_addr);
}

Ptr :: ~Ptr() {
}
