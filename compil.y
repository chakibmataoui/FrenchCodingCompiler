%{
  #include <stdio.h>
  #include "compil.h"
  extern FILE* yyin;
  extern int yylex(void);
  extern char* yytext;
  extern int yyerror(char*);
  extern int yylineno;
%}

%code requires {
    
}
%union {
  char idf[256];
  char keyW[256];
  struct val{char type[20]; char value[1000];} v;
  struct boolean{
    struct Liste *vrai;
    struct Liste *faux;
  } boolean;
  struct Liste *ver;
  int quad;
}
			
%token key_main key_code  key_acc_open key_acc_close key_dpoint key_croch_open key_croch_close key_point key_plus key_minus key_mult key_div key_sup_eq key_inf_eq key_sup key_inf key_not_eq key_is_eq key_and key_or key_eq key_verif key_autre key_tq key_par_open key_par_close key_virg key_point_virg key_idf key_float key_natural key_string key_natural_dec key_float_dec key_str_dec

%left key_or
%left key_and
%nonassoc key_sup key_sup_eq key_is_eq key_not_eq key_inf_eq key_inf
%left key_plus key_minus
%left key_mult key_div



%type<idf> key_idf
%type<keyW> key_plus key_minus key_mult key_div 
%type<keyW> key_float_dec key_str_dec key_natural_dec TYPE
%type<v> VALEUR_NUM EXP IDF key_float  key_natural key_string
%type<keyW> key_sup key_sup_eq key_inf key_inf_eq key_not_eq key_is_eq OPERATION_LOG
%type<boolean> CONDITION
%type<quad> M 
%type<ver> VERIF N BLOC_INST INST TANTQUE F

%start P

%%
   P: key_main key_acc_open BLOC_DEC key_acc_close key_code key_acc_open BLOC_INST key_acc_close
;

BLOC_DEC: DEC BLOC_DEC |
;

DEC: key_idf key_dpoint TYPE key_point_virg {
  if(declare($1) == 1){
    mise_a_jour_declaration($1);
    mise_a_jour_type($1,$3);
  }
  else
  yyerror("Erreur sémantique : Double déclaration");
 }
| key_idf key_croch_open key_natural key_croch_close key_dpoint TYPE key_point_virg {	  
  if(declare($1) == 1){
    mise_a_jour_declaration($1);
    mise_a_jour_type($1,$6);
    mise_a_jour_taille($1,atoi($3.value));
    mise_a_jour_nature($1,'T');
    generer_quad("BOUND","0",$3.value,"");
    generer_quad("ADEC",$1,"","");
  }
  else
    yyerror("Erreur sémantique : Double déclaration");
 }
;

 TYPE: key_natural_dec | key_float_dec | key_str_dec
;


BLOC_INST:  BLOC_INST M INST
{
  backpatch($2,$1);
  $$ = $3;
}| INST
{
  $$ = $1;
}
;

 INST: AFFECTATION key_point_virg 
 {
    //$$ = (Liste*)malloc(sizeof(Liste*));
    $$ = NULL;
 }
|VERIF
{
  
  $$ = $1;
}
|TANTQUE
{
  $$ = $1;
}
;

AFFECTATION: IDF key_eq key_string
{
  //On vérifie le type seulement
  if(!verif_type($1.type,"STRING")){
    yyerror("Erreur sémantique : type dans les opérations arithmétique ne s'accordent pas");
  }
  //generation quad
  generer_quad("=",$3.value,"",$1.value);
}
|IDF key_eq EXP
{
  //type idem
  if(!verif_type($1.type,$3.type)){
    yyerror("Erreur sémantique : type dans les opérations arithmétique ne s'accordent pas");
  }
  //generation quad
  generer_quad("=",$3.value,"",$1.value);
}
;

IDF : key_idf
{
  if(declare($1) == 1){
    yyerror("Erreur sémantique : Variable non déclaré");
  }
  if(nature($1,'T') == 1){
    yyerror("Erreur sémantique : utilisation d'une variable comme tableau");
  }
  strcpy($$.value,$1);
  strcpy($$.type,type($1));
}
|key_idf key_croch_open EXP key_croch_close
{
  if(declare($1) == 1){
    yyerror("Erreur sémantique : Variable non déclaré");
  }
  if(nature($1,'V') == 1){
    yyerror("Erreur sémantique : utilisation d'un tableau en variable");
  }
  sprintf($$.value,"%s[%s]",$1,$3.value);
  //strcpy($$.value,$1);
  strcpy($$.type,type($1));
}
;


EXP: EXP key_plus EXP
{
  //ON vérifie que les types s'accordent
  if(!verif_type($1.type,$3.type)){
    yyerror("Erreur sémantique : type dans les opérations arithmétique ne s'accordent pas");
  }
  char t[5];
  creertemp(t);
  mise_a_jour_type(t,retour_type_englobant($1.type,$3.type));
  mise_a_jour_nature(t,'V');
  mise_a_jour_declaration(t);
  generer_quad($2,$1.value,$3.value,t);
  strcpy($$.value,t);
  strcpy($$.type,type(t));
}
|
EXP key_minus EXP
{
  //ON vérifie que les types s'accordent
  if(!verif_type($1.type,$3.type)){
    yyerror("Erreur sémantique : type dans les opérations arithmétique ne s'accordent pas");
  }
  char t[5];
  creertemp(t);
  mise_a_jour_type(t,retour_type_englobant($1.type,$3.type));
  mise_a_jour_nature(t,'V');
  mise_a_jour_declaration(t);
  generer_quad($2,$1.value,$3.value,t);
  strcpy($$.value,t);
   strcpy($$.type,type(t));
}
|
EXP key_div EXP
{
  //ON vérifie que les types s'accordent
  if(!verif_type($1.type,$3.type)){
    yyerror("Erreur sémantique : type dans les opérations arithmétique ne s'accordent pas");
  }
  char t[5];
  creertemp(t);
  mise_a_jour_type(t,retour_type_englobant($1.type,$3.type));
  mise_a_jour_nature(t,'V');
  mise_a_jour_declaration(t);
  generer_quad($2,$1.value,$3.value,t);
  strcpy($$.value,t);
  strcpy($$.type,type(t));
}
|
EXP key_mult EXP
{
  //ON vérifie que les types s'accordent
  if(!verif_type($1.type,$3.type)){
    yyerror("Erreur sémantique : type dans les opérations arithmétique ne s'accordent pas");
  }
  char t[5];
  creertemp(t);
  mise_a_jour_type(t,retour_type_englobant($1.type,$3.type));
  mise_a_jour_nature(t,'V');
  mise_a_jour_declaration(t);
  generer_quad($2,$1.value,$3.value,t);
  strcpy($$.value,t);
  strcpy($$.type,type(t));
}
|VALEUR_NUM
{
  
}
;

VALEUR_NUM:key_natural |key_float |IDF {strcpy($$.type,$1.type);}
;




OPERATION_LOG:	key_sup| key_sup_eq| key_is_eq| key_not_eq| key_inf_eq| key_inf
;

CONDITION: CONDITION key_or M CONDITION
{
  backpatch($3,$1.faux);
  $1.vrai->next = $4.vrai;
  $$.vrai = $1.vrai;
  $$.faux = $4.faux;
}
|CONDITION key_and M CONDITION
{
  backpatch($3,$1.vrai);
  $$.vrai = $4.vrai;
  $1.faux->next = $4.faux;
  $$.faux = $1.faux;
  
}
| key_par_open CONDITION key_par_close
{
  $$ = $2;
}
|EXP OPERATION_LOG EXP
{
if(!verif_type($1.type,$3.type)){
  yyerror("Erreur sémantique : type dans les opérations arithmétique ne s'accordent pas");
  }
 
 generer_quad($2,$1.value,$3.value,"");
 generer_quad("BR","","","");
 //Creer liste
 $$.vrai = (struct Liste*)malloc(sizeof(struct Liste*));
 $$.vrai->qc = quad   - 2;
 $$.vrai->next = NULL;
 $$.faux = (struct Liste*)malloc(sizeof(struct Liste*));
 $$.faux->qc = quad  - 1;
 $$.faux->next = NULL;
}
;

M:  {$$ = quad;}	
	;

N:
{
  $$ = (struct Liste*)malloc(sizeof(struct Liste*));
  generer_quad("BR","","","");
  $$->qc = quad - 1;
  $$->next = (struct Liste*)malloc(sizeof(struct Liste*));
  $$->next->qc = quad  ;
}
;

VERIF:	key_verif key_par_open CONDITION M key_par_close key_acc_open BLOC_INST key_acc_close key_autre key_acc_open N BLOC_INST key_acc_close 
{
  backpatch($4,$3.vrai);
  backpatch($11->qc+1,$3.faux);
  $11->next = $12;
  if($7 != NULL)
    $7->next = $11;
  else
    $7 = $11;
  $$ = $7;
}
	;
TANTQUE: key_tq	key_par_open AFFECTATION key_virg key_par_open M CONDITION M key_par_close key_virg M AFFECTATION F key_par_close key_acc_open M BLOC_INST key_acc_close
{
  backpatch($16,$7.vrai);
  char qoi[5];
  sprintf(qoi,"%d",$11);
  generer_quad("BR","","",qoi);
  backpatch($8,$17);
  $$ = $7.faux;
  backpatch($6,$13);
}
	;
F:
{
  generer_quad("BR","","","");
  $$ = (struct Liste*)malloc(sizeof(struct Liste*));
  $$->qc = quad-1;
  $$->next = NULL;
};



%%
int main(int argc,char**argv){
  printf("Initialiser table des symboles et les quadruplets\n");
  init();
  quad_init();
  yyin = fopen(argv[1],"r");
  printf("Analyse syntaxico-sémantique\n");
  yyparse();
  afficher();
  affich_quad();
  optimisation();
  generation_code();
  
}

int yyerror(char* message){
  printf("\033[0;31m");
  printf("\nERROR: %s \"%s\" ligne : %d\n",message,yytext,yylineno);
  printf("\033[0m");
}

int yywrap(){
return 1;
}
