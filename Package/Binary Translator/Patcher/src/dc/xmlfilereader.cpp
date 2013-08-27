
#include <vector>
#include <string>

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "xmlfilereader.h"

XMLFileReader :: XMLFileReader(std::string filename) {
    LIBXML_TEST_VERSION

    doc = xmlReadFile(filename.c_str(), NULL, 0);
    root = xmlDocGetRootElement(doc);
}


XMLFileReader :: ~XMLFileReader() {
    xmlFreeDoc(doc);
    xmlCleanupParser();
}


std::vector<Insert*> XMLFileReader :: get_translate_nodes() {
    std::vector<Insert*> inserts;
    xmlNode *n, *n2, *n3;
    xmlChar *string;
    Insert  *insert;

    for (n = root->children; n; n = n->next) {
        if (n->type != XML_ELEMENT_NODE) continue;
        if (!strcmp((const char*)n->name, "script"))
          break;
    }

    for (n = n->children; n; n = n->next) {
        if (n->type != XML_ELEMENT_NODE) continue;

        if (!strcmp((const char*)n->name, "section")) {
            for (n2 = n->children; n2; n2 = n2->next) {
                if (n2->type != XML_ELEMENT_NODE) continue;

                if (!strcmp((const char*)n2->name, "translate")) {
                    string = xmlGetProp(n2, (const xmlChar*)"text");
                    insert = new Insert(std::string((const char*)string));
                    xmlFree(string);

                    for (n3 = n2->children; n3; n3 = n3->next) {
                        if (n3->type != XML_ELEMENT_NODE) continue;

                        if (!strcmp((const char*)n3->name, "ptr")) {
                            string = xmlGetProp(n3, (const xmlChar*)"addr");
                            insert->addPtr(strtol((const char*)string, NULL, 16));
                            xmlFree(string);
                        }
                    }

                    inserts.push_back(insert);
                }
            }
        }
    }

    return inserts;
}


std::vector<Insert*> XMLFileReader :: get_insert_nodes() {
    std::vector<Insert*> inserts;
    xmlNode *n, *n2;
    xmlChar *string;
    Insert  *insert;


    for (n = root->children; n; n = n->next) {
        if (n->type != XML_ELEMENT_NODE) continue;
        if (!strcmp((const char*)n->name, "script"))
          break;
    }

    for (n = n->children; n; n = n->next) {
        if (n->type != XML_ELEMENT_NODE) continue;

        if (!strcmp((const char*)n->name, "insert")) {
            string = xmlGetProp(n, (const xmlChar*)"text");
            insert = new Insert(std::string((const char*)string));
            xmlFree(string);

            for (n2 = n->children; n2; n2 = n2->next) {
                if (n2->type != XML_ELEMENT_NODE) continue;

                if (!strcmp((const char*)n2->name, "ptr")) {
                    string = xmlGetProp(n2, (const xmlChar*)"addr");
                    insert->addPtr(strtol((const char*)string, NULL, 16));
                    xmlFree(string);
                }
            }

            inserts.push_back(insert);
        }
    }

    return inserts;
}


std::vector<Insert*> XMLFileReader :: get_all_inserts() {
    std::vector<Insert*> inserts;

    std::vector<Insert*> first = get_insert_nodes();
    std::vector<Insert*> second = get_translate_nodes();

    while(!first.empty()) {
        inserts.push_back(first[first.size()-1]);
        first.pop_back();
    }

    while(!second.empty()) {
        inserts.push_back(second[second.size()-1]);
        second.pop_back();
    }

    return inserts;
}


bool XMLFileReader :: getAddrBase(uint32_t *addrbase) {
    xmlChar *string;
    xmlNode *n;

    for (n = root->children; n; n = n->next) {
        if ((n->type == XML_ELEMENT_NODE) && !strcmp((const char*)n->name, "header")) {
            string = xmlGetProp(n, (const xmlChar*)"addrbase");
            *addrbase = strtol((const char*)string, NULL, 16);
            xmlFree(string);
            return true;
        }
    }
    return false;
}


unsigned int XMLFileReader :: loadAllocationTable(MemoryManager *mm) {
    xmlChar *string;
    xmlNode *n, *tmp;
    uint32_t addr, size;
    unsigned int nb = 0;

    for (n = root->children; n; n = n->next) {
        if ((n->type == XML_ELEMENT_NODE) && !strcmp((const char*)n->name, "allocation_table")) {
            for (tmp = n->children; tmp; tmp = tmp->next) {
                if ((tmp->type == XML_ELEMENT_NODE) && !strcmp((const char*)tmp->name, "block")) {
                    string = xmlGetProp(tmp, (const xmlChar*)"addr");
                    addr = strtol((const char*)string, NULL, 16);
                    xmlFree(string);
                    string = xmlGetProp(tmp, (const xmlChar*)"size");
                    if (!string) printf("test2\n");
                    size = strtol((const char*)string, NULL, 16);
                    xmlFree(string);
                    mm->insertNewBlock(addr, size);
                    nb++;
                }
            }
        }
    }
    return nb;
}
