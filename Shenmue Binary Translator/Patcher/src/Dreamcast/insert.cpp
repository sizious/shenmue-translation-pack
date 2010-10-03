
#include <string>
#include <vector>
#include "insert.h"

void Insert :: addPtr(uint32_t addr) {
    ptrs.push_back(new Ptr(addr));
}


std::string Insert :: getText() {
    return text;
}


std::vector<Ptr*> Insert :: getPtrs() {
    return ptrs;
}


void Insert :: setText(std::string _text) {
    text = _text;
}


Insert :: Insert(std::string _text) {
    setText(_text);
}


Insert :: ~Insert() {
    unsigned int i;
    for (i=0; i<ptrs.size(); i++)
      delete ptrs[i];
}


bool Insert :: operator<(const Insert &i) const {
    return text.size() < i.text.size();
}
