
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define DC_PROG_START 0x8c010000
#define MAX_STRING_SIZE 0x1000


struct CustomString {
    char *str;
    unsigned long ptrs[0x100];
    unsigned int index;
};


// String correcte selon Shenmue.
// TODO: ne devrait pas dépendre de Shenmue mais être global à tous les jeux DC...
int string_correcte(char* string) {
    char i=1,tmp, nb=0;

    while(i && *string) {
        nb++;
        tmp = *(string+1);
        i = ((*string >=0x20) && (*string <= 0x7c)) || ((*string == 0xa5) && ((tmp == 0xae) || (tmp == 0xbb) || ((tmp >= 0xc2) && (tmp <= 0xc6)) || (tmp == 0xca) || (tmp == 0xde) || (tmp == 0xdf) | (tmp == 0xe1) || (tmp == 0xe2)));
        string++;
    }

    return (nb > 1) && i;
}


int main(int argc, char** argv) {

    if (argc < 2) {
        printf("Usage: %s [-n value] 1st_read.bin\n-n: Set the start address (default 0x8c010000)\n", argv[0]);
        return 0;
    }

    uint32_t start_addr;
    char *filename;
    if (!strcmp(argv[1], "-n")) {
        start_addr = strtol(argv[2], NULL, 16);
        filename = argv[3];
    } else {
        start_addr = DC_PROG_START;
        filename = argv[1];
    }


    FILE *binaire = fopen(filename, "r");

    if (!binaire) {
        printf("Impossible d'ouvrir %s.\n", argv[1]);
        return -1;
    }


    unsigned int i,j,nb=0;
    char string[MAX_STRING_SIZE];
    uint32_t opcode;


    fseek(binaire, 0, SEEK_END);
    unsigned int binary_size = ftell(binaire);

    // On crée un buffer de la taille du fichier.
    uint32_t buffer[binary_size >>2];

    // Chaque case de ce tableau est initialisée à 0.
    for(i=0; i<binary_size >> 2; i++)
      buffer[i] = 0;

    rewind(binaire);

    // Pour chaque mot de 32 bits contenu dans le binaire,
    while (fread(&opcode, sizeof(uint32_t), 1, binaire) ) {

        // on teste si ce mot est un pointeur, soit que son contenu
        // est une adresse pointant à l'intérieur du binaire chargé en RAM.
        if ((opcode > start_addr) && (opcode < (start_addr + binary_size))) {

            // Si c'est le cas, on incrémente la valeur contenue dans la case
            // correspondante à l'adresse pointée moins l'adresse
            // de base du programme en RAM.
            if(!buffer[(opcode - start_addr) >> 2])
                nb++;

            buffer[(opcode - start_addr) >> 2]++;
        }
    }

    // On crée un nouveau buffer, dans lequel on place toutes les adresses
    // pointées par un pointeur quelconque.
    int buffer2[nb];
    j=0;
    for(i=0; i<(binary_size >> 2); i++) {
        if (buffer[i]) {
            buffer2[j++] = i << 2;
        }
    }

    // Puis, on crée le buffer qui va contenir les chaînes de caractère,
    // et la liste des pointeurs associés (permet de supprimer les doublons).
    struct CustomString *cstrs = calloc(nb, sizeof(struct CustomString));

    // Pour chaque adresse contenue dans le buffer,
    for(i=0; i<nb; i++) {
        fseek(binaire, buffer2[i], SEEK_SET);

        // on charge un nombre donné de caractères dans le buffer "string".
        fread(string, sizeof(char), MAX_STRING_SIZE, binaire);

        // S'il s'avère que les caractères recopiés forment une string correcte
        // (selon Shenmue), et si cette dernière n'est pas déjà présente dans la liste,
        // on l'y ajoute.
        if (string_correcte(string)) {
            for (j=0; j<nb; j++) {
                if (cstrs[j].str) {
                    if (strcmp(cstrs[j].str, string))
                      continue;

                    // Si la string est déjà présente, on met à jour la liste des pointeurs.
                    cstrs[j].ptrs[cstrs[j].index++] = buffer2[i];
                    break;
                } else {   // Sinon, on l'y ajoute:
                    cstrs[j].str = malloc(strlen(string)+1);
                    strcpy(cstrs[j].str, string);
                    cstrs[j].ptrs[cstrs[j].index++] = buffer2[i];
                    break;
                }
            }
        }
    }

    struct CustomString *tmp = cstrs;

    // Enfin, on affiche chaque string trouvée associée de sa liste de pointeurs,
    while (tmp->str) {
        printf("translate: ");
        for (i=0; i < tmp->index; i++)
          printf("0x%lx ", tmp->ptrs[i]);
        printf("\"%s\"\n", tmp->str);
        tmp++;

        // Et on libère la mémoire utilisée.
        free(tmp->str);
    }

    free(cstrs);
    fclose(binaire);

    return 0;
}
