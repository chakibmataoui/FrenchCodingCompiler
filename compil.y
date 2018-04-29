%{
  #include <stdio.h>
  //#include "compil.h"
  extern FILE* yyin;
  extern int yylex(void);
  extern char* yytext;
  extern int yyerror(char*);
  extern int yylineno;
%}

%union {
  char m[100];
  int tab[256];
}
			
%token key_main key_code  key_acc_open key_acc_close key_dpoint key_croch_open key_croch_close key_point key_plus key_minus key_mult key_div key_sup_eq key_inf_eq key_sup key_inf key_not_eq key_is_eq key_and key_or key_eq key_verif key_autre key_tq key_par_open key_par_close key_virg key_point_virg key_idf key_float key_natural key_string key_natural_dec key_float_dec key_str_dec

%left key_or
%left key_and
%left key_sup key_sup_eq key_is_eq key_not_eq key_inf_eq key_inf
%left key_plus key_minus
%left key_mult key_div

%start P

%%
   P: key_main key_acc_open BLOC_DEC key_acc_close key_code key_acc_open BLOC_INST key_acc_close
;
 BLOC_DEC: DEC BLOC_DEC |
;
 DEC: key_idf key_dpoint TYPE key_point_virg
	| key_idf key_croch_open key_natural key_croch_close key_dpoint TYPE key_point_virg
;
 TYPE: key_natural_dec | key_float_dec | key_str_dec
;
 BLOC_INST:INST BLOC_INST |
;
 INST: AFFECTATION key_point_virg|VERIF |TANTQUE
;
 AFFECTATION: IDF key_eq key_string|IDF key_eq EXP
;
IDF : key_idf|key_idf key_croch_open EXP key_croch_close
;
VALEUR_NUM:key_natural|key_float|IDF
	;
EXP: VALEUR_NUM OPERATION_AR EXP|VALEUR_NUM
	;
OPERATION_AR: key_plus|key_minus|key_mult|key_div
	;
VERIF:	key_verif key_par_open CONDITION key_par_close key_acc_open BLOC_INST key_acc_close  key_autre key_acc_open BLOC_INST key_acc_close
	;
CONDITION:EXP_LOG OPERATEUR_LOG CONDITION|EXP_LOG
	;
EXP_LOG: EXP OPERATION_LOG EXP| key_par_open EXP OPERATION_LOG EXP key_par_close;
	;
OPERATEUR_LOG:	key_or|key_and
	;
OPERATION_LOG:	key_sup| key_sup_eq| key_is_eq| key_not_eq| key_inf_eq| key_inf
	;
TANTQUE: key_tq	key_par_open AFFECTATION key_virg key_par_open CONDITION key_par_close key_virg AFFECTATION key_par_close key_acc_open BLOC_INST key_acc_close
	;

%%
int main(int argc,char**argv){
    init();
    yyin = fopen(argv[1],"r");
    yyparse();
    afficher();
}

int yyerror(char* message){
  printf("\nERROR: %s \"%s\" ligne : %d\n",message,yytext,yylineno);
}

int yywrap(){
return 1;
}
