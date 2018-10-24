#ifndef TP1_H
#define TP1_H
#include <string.h>
#include <ctype.h>

/* 
   Table des symboles
                       */
typedef struct symbol_table{
  int al;
  char name[255];
  char type[255];
  char nature;
  int taille;
  struct symbol_table *next;
} symbol_table;
symbol_table *t;
static char last_type[255];
//Fonction de hashage TS
unsigned long hash_function(char* sym);
//Init TS
void init();
//Ajouter TS .l
void ajouter(char* sym);
//Afficher TS
void afficher();
//Ts declaré ou pas par le .l
int declare(char* sym);
int nature(char* sym,char nat);
char* type(char* sym);
//Recheche TS
symbol_table* search_sym(char* sym);
//Mise a jour TS
void mise_a_jour_type(char* sym,char* type);
void mise_a_jour_nature(char* sym,char nature);
void mise_a_jour_taille(char* sym,int taille);
void mise_a_jour_declaration(char* sym);

/*
      Sémantique
                     */
int verif_type(char*,char*);
char* retour_type_englobant(char*,char*);


/*
      Quadruplets
                     */

typedef struct quadruplet{
  char op[10];
  char arg1[255];
  char arg2[255];
  char ret[10];
} quadruplet;
quadruplet q[1000]; //Matrice des quads


struct Liste{
    int qc;
    struct Liste* next;
    };
    typedef struct Liste Liste;
void quad_init(); //Capacité 1000 quads
void generer_quad(char* op,char* arg1,char* arg2,char* ret);
void creertemp(char* temp);
int quad;
int indice;
void affich_quad();

void backpatch(int quad,Liste *second);

/*
      Generation de code et optimisation
                                             */
void generation_code();
void optimisation();
int is_number(char* c);
int is_jmp(char* line);
#endif
