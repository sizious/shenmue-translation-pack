
#include <vector>
#include <string>

#include <string.h>
#include <stdio.h>

#include "insert.h"
#include "memorymanager.h"
#include "iohandler.h"
#include "xmlfilereader.h"


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

    std::string filename(argv[1]);
    XMLFileReader reader(filename);
    printf("XML file reader created.\n");

    if (!copy_file(argv[2], argv[3])) {
        fprintf(stderr, "error: unable to copy file (please check the filenames you provided)\n");
        return 1;
    }
    printf("file copied.\n");

    uint32_t addrbase;
    if (!reader.getAddrBase(&addrbase)) {
        fprintf(stderr, "Error: unable to load base address from XML file.\n");
        return 2;
    }

    std::vector<Insert*> inserts = reader.get_all_inserts();
    if (inserts.empty()) {
        fprintf(stderr, "Error: unable to read data.\n");
        return 3;
    }

    IOHandler handler(argv[3], addrbase);
    printf("IOHandler created.\n");

    MemoryManager mm(&handler);
    printf("Memory manager created.\n");

    if (!reader.loadAllocationTable(&mm)) {
        fprintf(stderr, "Error: unable to load allocation table.\n");
        return 4;
    }
    printf("Allocation table loaded.\n");

    mm.insertStrings(inserts);
}
