#ifndef TP1_H
#define TP1_H
#include <string.h>
typedef struct symbol_table{
    char name[10];
    char type[255];
  } symbol_table;
symbol_table t[1000];
int last_entry = 0;
static char last_type[255];

void ajouter(char* sym){
  int exist = 0;
  for(int i = 0; i < last_entry;++i){
    if(strcmp(sym,t[i].name) == 0)
      exist = 1;
  }
  if(exist)return;
  strcpy(t[last_entry].name,sym);
  strcpy(t[last_entry].type,"");
  last_entry++;
}
void afficher(){
  printf("\n\n\ntables des symboles : %d\n",last_entry);
  printf("IDF\tTYPE\n");
  for(int i = 0; i < last_entry;++i)
    printf("%s\t%s\n",t[i].name,t[i].type);
}

void mise_a_jour(char* sym,char* type){
  for(int i = 0; i < last_entry;++i){
    if(strcmp(sym,t[i].name) == 0){
      strcpy(t[i].type,type);
    }
  }
}
#endif
