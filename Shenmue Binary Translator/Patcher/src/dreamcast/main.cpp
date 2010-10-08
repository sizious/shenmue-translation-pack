
#include <vector>
#include <string>

#include <string.h>
#include <stdio.h>

#include <libxml/parser.h>
#include <libxml/tree.h>

#include "insert.h"
#include "memorymanager.h"
#include "iohandler.h"

static std::vector<Insert*> get_all_inserts(const xmlNode *root) {
    std::vector<Insert*> inserts;
    xmlNode *cur_node, *node2, *node3;
    Insert *cur_insert;
    xmlChar *string;

    for (cur_node = root->children; cur_node; cur_node = cur_node->next) {
        if ((cur_node->type == XML_ELEMENT_NODE) && !strcmp((const char*)cur_node->name, "script"))
            break;
    }

    for (cur_node = cur_node->children; cur_node; cur_node = cur_node->next) {
        if (cur_node->type != XML_ELEMENT_NODE)
            continue;

        if (!strcmp((const char*)cur_node->name, "section")) {
            for(node2 = cur_node->children; node2; node2 = node2->next) {
                if (node2->type != XML_ELEMENT_NODE)
                  continue;

                if (!strcmp((const char*)node2->name, "translate")) {
                    string = xmlGetProp(node2, (const xmlChar*)"text");
                    cur_insert = new Insert(std::string((const char*)string));
                    xmlFree(string);

                    for (node3 = node2->children; node3; node3 = node3->next) {
                        if (node3->type == XML_ELEMENT_NODE && !strcmp((const char*)node3->name, "ptr")) {
                            string = xmlGetProp(node3, (const xmlChar*)"addr");
                            cur_insert->addPtr(strtol((const char*)string, NULL, 16));
                            xmlFree(string);
                        }
                    }

                    inserts.push_back(cur_insert);
                }
            }
            continue;
        }

        if (!strcmp((const char*)cur_node->name, "insert")) {
            string = xmlGetProp(cur_node, (const xmlChar*)"text");
            cur_insert = new Insert(std::string((const char*)string));
            xmlFree(string);

            for (node2 = cur_node->children; node2; node2 = node2->next) {
                if (node2->type == XML_ELEMENT_NODE && !strcmp((const char*)node2->name, "ptr")) {
                    string = xmlGetProp(node2, (const xmlChar*)"addr");
                    cur_insert->addPtr(strtol((const char*)string, NULL, 16));
                    xmlFree(string);
                }
            }

            inserts.push_back(cur_insert);
        }
    }

    return inserts;
}


static bool getAddrBase(const xmlNode *root, uint32_t *addrbase) {
    xmlChar *string;
    xmlNode *cur_node;

    for (cur_node = root->children; cur_node; cur_node = cur_node->next) {
        if ((cur_node->type == XML_ELEMENT_NODE) && !strcmp((const char*)cur_node->name, "header")) {
            string = xmlGetProp(cur_node, (const xmlChar*)"addrbase");
            *addrbase = strtol((const char*)string, NULL, 16);
            xmlFree(string);
            return true;
        }
    }
    return false;
}


static unsigned int loadAllocationTable(const xmlNode *root, MemoryManager *mm) {
    xmlChar *string;
    xmlNode *cur_node, *tmp;
    uint32_t addr, size;
    unsigned int nb = 0;

    for (cur_node = root->children; cur_node; cur_node = cur_node->next) {
        if ((cur_node->type == XML_ELEMENT_NODE) && !strcmp((const char*)cur_node->name, "allocation_table")) {
            for (tmp = cur_node->children; tmp; tmp = tmp->next) {
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


static bool copy_file(const char *f1, const char *f2) {
    unsigned int length = 0x100;
    size_t nbRead = 0;

    void *buffer = malloc(length);
    if (!buffer) return false;

    FILE *in = fopen(f1, "rb");
    FILE *out = fopen(f2, "wb+");
    if ((!in) || (!out)) {
        free(buffer);
        return false;
    }


    while(!feof(in)) {
        nbRead = fread(buffer, sizeof(char), length, in);
        fwrite(buffer, sizeof(char), nbRead, out);
    }

    fclose(out);
    fclose(in);
    free(buffer);
    return true;
}


int main(int argc, char **argv) {

    if (argc < 4) {
        printf("1ST_READ.BIN Patcher by Ayla.\n\nUsage:\n\t%s translation.xml input.bin output.bin\n", argv[0]);
        return 0;
    }

    xmlDoc *doc = NULL;
    xmlNode *root = NULL;

    LIBXML_TEST_VERSION

    doc = xmlReadFile(argv[1], NULL, 0);

    if (!doc) {
        fprintf(stderr, "Unable to parse the file \"%s\".\n", argv[1]);
        return 1;
    }

    root = xmlDocGetRootElement(doc);

    std::vector<Insert*> inserts = get_all_inserts(root);
    if (!inserts.size()) {
        fprintf(stderr, "Error: unable to load inserts.\n");
        return 2;
    }
    printf("Inserts extracted.\n");

    if (!copy_file(argv[2], argv[3])) {
        fprintf(stderr, "Error: unable to copy file (please check the filenames you provided)\n");
        return 3;
    }
    printf("File copied.\n");

    uint32_t addrbase;
    if (!getAddrBase(root, &addrbase)) {
        fprintf(stderr, "Error: unable to load base address from XML file.\n");
        return 4;
    }
    IOHandler handler(argv[3], addrbase);
    printf("IOHandler created.\n");

    MemoryManager mm(&handler);
    printf("Memory manager created.\n");

    if (!loadAllocationTable(root, &mm)) {
        fprintf(stderr, "Error: unable to load allocation table.\n");
        return 5;
    }
    printf("Allocation table loaded.\n");

    mm.insertStrings(inserts);
}
