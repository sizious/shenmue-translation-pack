
#ifndef PTR_H
#define PTR_H

#include <stdint.h>

class Ptr {
    private:
        uint32_t addr;

    public:
        uint32_t getAddr();
        void setAddr(uint32_t addr);

        Ptr(uint32_t addr);
        ~Ptr();
};

#endif
