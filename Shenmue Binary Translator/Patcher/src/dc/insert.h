
#ifndef INSERT_H
#define INSERT_H

#include <stdint.h>
#include "ptr.h"

class Insert {
    private:
        std::vector<Ptr*> ptrs;
        std::string text;

    public:
        void addPtr(uint32_t addr);
        std::string getText();
        void setText(std::string text);
        std::vector<Ptr*> getPtrs();

        Insert(std::string text);
        ~Insert();

        bool operator<(const Insert &i) const;
};

#endif
