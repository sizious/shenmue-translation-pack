
#ifndef XMLFILEREADER_H
#define XMLFILEREADER_H

#include <libxml/parser.h>
#include <libxml/tree.h>

#include "insert.h"
#include "memorymanager.h"

class XMLFileReader {
    private:
        xmlDoc *doc;
        xmlNode *root;

        std::vector<Insert*> get_translate_nodes();
        std::vector<Insert*> get_insert_nodes();

    public:
        std::vector<Insert*> get_all_inserts();
        bool getAddrBase(uint32_t *addrbase);
        unsigned int loadAllocationTable(MemoryManager *mm);

        XMLFileReader(std::string filename);
        ~XMLFileReader();
};

#endif
