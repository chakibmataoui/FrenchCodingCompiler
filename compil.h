#ifndef TP1_H
#define TP1_H
#include <string.h>
typedef struct symbol_table{
  int al;
  char name[10];
  char type[255];
  char nature;
  int taille;
} symbol_table;
symbol_table *t;
static char last_type[255];

void init(){
  int size = ((int)'z')*8+1;
  t = (symbol_table*)malloc(size*sizeof(symbol_table));
  for(int i = 0; i < size;++i)
    t[i].al = 0;
}

void ajouter(char* sym){
  int val = 0;
  for(int i = 0; i < strlen(sym);++i)
    val += (int)sym[i];
  if(t[val].al == 0){
    strcpy(t[val].name,sym);
    strcpy(t[val].type,"");
    t[val].nature = "";
    t[val].taille = -1;
    t[val].al = 1;
  }
}
 void afficher(){
  printf("\n\n\ntables des symboles :\n");
  printf("IDF\tTYPE\tNATURE\tTAILLE\n");
  for(int i = 0; i < ((int)'z')*8;++i)
    if(t[i].al != 0)
      printf("%s\t%s\n",t[i].name,t[i].type);
}

void mise_a_jour_type(char* sym,char* type){
  int val = 0;
  for(int i = 0; i < strlen(sym);++i)
    val += (int)sym[i];
  if(t[val].al == 0){
    strcpy(t[val].name,sym);
    strcpy(t[val].type,"");
    t[val].nature = "";
    t[val].taille = -1;
    t[val].al = 1;
  }
}
#endif
