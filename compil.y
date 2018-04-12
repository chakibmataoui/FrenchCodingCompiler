%{
  #include <stdio.h>
  // #include "tp1.h"
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
%type <m> key_idf;
%type <m> key_integer TYPE;
%type <tab> IDFB;
%token key_program key_idf key_point_virgule key_var key_integer key_begin key_end key_dpoint_egale key_dpoint key_plus key_moins key_multiplication key_division key_virgule key_number

%left key_plus key_moins
%left key_multiplication key_division

%start P

%%
   P: key_program key_idf key_point_virgule key_var BLOC_DEC key_begin BLOC_INST key_end  {printf("\n____%s\n",$2);}
   ;
 BLOC_DEC: DEC BLOC_DEC |;
 DEC: IDFB key_dpoint TYPE key_point_virgule ;
 IDFB: key_idf {printf("\n____%s\n",$1);}
   | IDFB key_virgule key_idf {printf("\n____%s\n",$3);}
   ;
 TYPE: key_integer;
 BLOC_INST:INST BLOC_INST | ;
 INST: key_idf key_dpoint_egale EXP key_point_virgule {printf("\n____%s\n",$1);};
 EXP: EXP key_plus EXP | key_idf {printf("\n____%s\n",$1);} | key_number;

%%
int main(int argc,char**argv){
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
