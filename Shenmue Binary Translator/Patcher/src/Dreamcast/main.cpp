
#include <vector>
#include <string>

#include <stdio.h>
#include <string.h>

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


static uint32_t getAddrBase(const xmlNode *root) {
    return 0x8c010000;
}


static void loadAllocationTable(const xmlNode *root, MemoryManager *mm) {

}


void copy_file(const char *f1, const char *f2) {
    FILE *in = fopen(f1, "rb");
    FILE *out = fopen(f2, "wb");

    fseek(in, 0, SEEK_END);
    unsigned int length = ftell(in);
    rewind(in);

    char *buffer = (char*)malloc(length);
    fread(buffer, sizeof(char), length, in);
    fwrite(buffer, sizeof(char), length, out);

    free(buffer);
    fclose(in);
    fclose(out);
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
        printf("Erreur: array vide.\n");
        return 2;
    }
    printf("Inserts extracted.\n");

    copy_file(argv[2], argv[3]);
    printf("File copied.\n");

    IOHandler handler(argv[3], getAddrBase(root));
    printf("IOHandler created.\n");

    MemoryManager mm(&handler);
    printf("Memory manager created.\n");

    loadAllocationTable(root, &mm);
    printf("Allocation table loaded.\n");

    //mm.insertStrings();
}
