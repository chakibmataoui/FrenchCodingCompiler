#include "compil.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
unsigned long hash_function(char* sym){
  unsigned long val = 0;
  for(int i = 0; i < strlen(sym);++i)
    val = (int)sym[i] +  val;
  return val;
}

void init(){
  unsigned long size =hash_function("zzzzzzzz");
  t = (symbol_table*)malloc(size*sizeof(symbol_table));
  if(t != NULL){
  for(int i = 0; i < size;++i)
    t[i].nature = 0;
  }
  else{
    printf("couldn't initialize hash table");
    exit(-1000);
  }
}

void ajouter(char* sym){
  //int val = 0;
  if(search_sym(sym) != NULL)return;
  unsigned long val = hash_function(sym);
  if(t[val].nature == 0){
    strcpy(t[val].name,sym);
    strcpy(t[val].type,"");
    t[val].nature = 'V';
    t[val].taille = 1;
    t[val].al = 0;
    t[val].next = NULL;
  }
  else{
    symbol_table *n = &t[val];
    while(n->next != NULL){n = n->next; }
    symbol_table *new_t  = (symbol_table*)malloc(sizeof(symbol_table));
    strcpy(new_t->name,sym);
    strcpy(new_t->type,"");
    new_t->nature = 'V';
    new_t->taille = 1;
    new_t->al = 0;
    new_t->next = NULL;
    n->next = new_t;
  }
}
 void afficher(){
  printf("\n\n\ntables des symboles :\n");
  printf("%-10s%-10s%-10s%-10s\n","IDF","TYPE","NATURE","TAILLE");
  for(int i = 0; i < hash_function("zzzzzzzz");++i){
    if(t[i].nature != 0){
      symbol_table *n = &t[i];
      
      while(n != NULL){
	printf("%-10s%-10s%-10c%-10d\n",n->name,n->type,n->nature,n->taille);
	n = n->next;
      }
    }
  }
}
int declare(char* sym){
  symbol_table *n = search_sym(sym);
  if(n != NULL)
    return !n->al;
}
int nature(char* sym,char nat){
  symbol_table *n = search_sym(sym);
  if(n != NULL)
    return n->nature == nat;
}
char* type(char* sym){
  symbol_table *n = search_sym(sym);
  if(n != NULL)
    return n->type;
}
symbol_table* search_sym(char* sym){
  unsigned long val = hash_function(sym);
  symbol_table *n = &t[val];
  while(n != NULL){
    if(strcmp(n->name,sym) == 0)
      return n;
      n = n->next;
  }
  return NULL;

}
void mise_a_jour_declaration(char* sym){
  symbol_table *n = search_sym(sym);
  n->al = 1;
}
void mise_a_jour_type(char* sym,char* type){
  symbol_table *n = search_sym(sym);
  strcpy(n->type,type);
}
void mise_a_jour_nature(char* sym,char nature){
  symbol_table *n = search_sym(sym);
  n->nature = nature; 
}
void mise_a_jour_taille(char* sym,int taille){
  symbol_table *n = search_sym(sym);
  n->taille = taille; 
}

int verif_type(char* t1,char* t2){
  if(strcmp(t1,t2) == 0)
    return 1;
  if(strcmp(t1,"FLOAT") == 0 && strcmp(t2,"NATURAL") == 0)
    return 1;
  /*if(strcmp(t1,"NATURAL") == 0 && strcmp(t2,"FLOAT") == 0)
    return 1;*/
  return 0;
}
char* retour_type_englobant(char* t1,char* t2){
  if(strcmp(t1,"NATURAL") == 0 && strcmp(t1,t2) == 0)
    return "NATURAL";
  if(strcmp(t1,"FLOAT")  == 0 && strcmp(t1,t2)  == 0)
    return "FLOAT";
  else
    return "FLOAT";
}

void quad_init(){
  quad = 0;
  indice = 1;
}
void generer_quad(char* op,char* arg1,char* arg2,char* ret){
  strcpy(q[quad].op,op);
  strcpy(q[quad].arg1,arg1);
  strcpy(q[quad].arg2,arg2);
  strcpy(q[quad].ret,ret);
  quad++;
}
void creertemp(char* temp){
  sprintf(temp,"t%d",indice);
  indice++;
  ajouter(temp);
}
void affich_quad(){
  printf("\nAffichage des quadruplets : \n\n");
  for(int i = 0; i < quad;++i){
    printf("%d( %s , %s , %s , %s )\n",i,q[i].op,q[i].arg1,q[i].arg2,q[i].ret);
  }
}

void backpatch(int quad,Liste *second){
  Liste *qd = second;
  while(qd != NULL){
    sprintf(q[qd->qc].ret,"%d",quad);
    // strcpy(q[qd->qc].ret,itoa(quad,10));
    qd = qd->next;
  }
}

void generation_code(){
  printf("\n\nGeneration de code objet :\n");
  for(int i = 0; i < quad; ++i){
    printf("%2d : ",i);
    char line[10];
    sprintf(line,"%d",i);
    if(is_jmp(line)){
      printf("Label_%2d : ",i);
    }
    else
      printf("%10s","");
    //AFFECTATION
    if(strcmp(q[i].op,"=") == 0){
      
      //Si c'est un nombre faire une assignation normal
      if(is_number(q[i].arg1) == 1){
	printf(" MOV %s,%s",q[i].ret,q[i].arg1);
      }
      else{
	//Sinon mettre dans le AX puis faire une assignasion
	printf("\t MOV AX,%s\n",q[i].arg1);
	printf("\t\t MOV %s,AX\n",q[i].ret);
      }
      
    }
    //COMPARAISON
    if(strcmp(q[i].op,"<") == 0){
      printf(" CMP %s,%s\n",q[i].arg1,q[i].arg2);
      printf("\t\t JB Label_%s\n",q[i].ret);
    }
    if(strcmp(q[i].op,">") == 0){
      printf(" CMP %s,%s\n",q[i].arg1,q[i].arg2);
      printf("\t\t JA Label_%s\n",q[i].ret);
    }
    if(strcmp(q[i].op,"<=") == 0){
      printf(" CMP %s,%s\n",q[i].arg1,q[i].arg2);
      printf("\t\t JBE Label_%s\n",q[i].ret);
    }
    if(strcmp(q[i].op,">=") == 0){
      printf(" CMP %s,%s\n",q[i].arg1,q[i].arg2);
      printf("\t\t JAE Label_%s\n",q[i].ret);
    }
    if(strcmp(q[i].op,"==") == 0){
      printf(" CMP %s,%s\n",q[i].arg1,q[i].arg2);
      printf("\t\t JE Label_%s\n",q[i].ret);
    }
    if(strcmp(q[i].op,"!=") == 0){
      printf(" CMP %s,%s\n",q[i].arg1,q[i].arg2);
      printf("\t\t JNE Label_%s\n",q[i].ret);
    }
    //JUMP
    if(strcmp(q[i].op,"BR") == 0){
      printf("\t JMP Label_%s\n",q[i].ret);
    }
    //OP
    if(strcmp(q[i].op,"+") == 0){
      printf(" ADD %s,%s\n",q[i].arg1,q[i].arg2);
      printf("\t\t MOV AX,%s\n",q[i].arg1);
      printf("\t\t MOV %s,AX\n",q[i].ret);
    }
    if(strcmp(q[i].op,"-") == 0){
      printf(" MOV AX,%s\n",q[i].arg1);
      printf("\t\t SUB AX,%s\n",q[i].arg2);
      printf("\t\t MOV %s,AX\n",q[i].ret);
    }
    if(strcmp(q[i].op,"*") == 0){
      printf(" MUL %s,%s\n",q[i].arg1,q[i].arg2);
      printf("\t\t MOV AX,%s\n",q[i].arg1);
      printf("\t\t MOV %s,AX\n",q[i].ret);
    }
    if(strcmp(q[i].op,"/") == 0){
      printf("\t\t MOV AX,%s\n",q[i].arg1);
      printf("\t\t DIV AX,%s\n",q[i].arg2);
      printf("\t\t MOV %s,AX\n",q[i].ret);
    }
    printf("\n");
  }
}

void optimisation(){
  quadruplet qn[1000];
  int quad_n = 0;
  //Propagation
  // Simplification algébrique
  //Elimination de code inutile
  //Elimination d'expressions redondantes
  for(int i = 0; i < quad;++i){
    
  }
}
int is_number(char* c){
  for(int i = 0; i < strlen(c); ++i){
    if(isdigit(c[i]) == 0 && c[i] != '.')
      return 0;
  }
  return 1;
}

int is_jmp(char* line){
  int jmp = 0;
  for(int i = 0; i < quad;++i){
    if(strcmp(q[i].ret,line) == 0){
      jmp = 1;
      break;
    }
  }
    
  return jmp;
}
