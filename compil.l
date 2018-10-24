%{
#include <stdio.h>
#include <string.h>
#include "compil.h"
#include "compil.tab.h"

  extern int yyline;
  extern int yyerror(char*);
  //extern char* yylval;
%}

idf [a-z]*
val_natural [0-9]*
val_float [0-9]*\.[0-9]*
val_string \'.*\'
comment \$.*\n
%%
"MAIN" {printf("%s",yytext);return key_main;}
"CODE" {printf("%s",yytext);return key_code;}


"{" {printf("%s",yytext);return key_acc_open;}
"}" {printf("%s",yytext);return key_acc_close;}

{comment} {printf("%s",yytext);yylineno++;}

":" {printf("%s",yytext);return key_dpoint;}
"[" {printf("%s",yytext);return key_croch_open;}
"]" {printf("%s",yytext);return key_croch_close;}

"." {printf("%s",yytext);return key_point;}

"\n" {printf("%s",yytext);yylineno++;}
"\t" {printf("%s",yytext);}

"NATURAL" {printf("%s",yytext);strcpy(yylval.keyW,yytext);return key_natural_dec;}
"FLOAT" {printf("%s",yytext);strcpy(yylval.keyW,yytext);return key_float_dec;}
"STRING" {printf("%s",yytext);strcpy(yylval.keyW,yytext);return key_str_dec;}

"+" {strcpy(yylval.keyW,yytext);return key_plus;}
"-" {strcpy(yylval.keyW,yytext);return key_minus;}
"*" {strcpy(yylval.keyW,yytext);return key_mult;}
"/" {strcpy(yylval.keyW,yytext);return key_div;}

">=" {strcpy(yylval.keyW,yytext);return key_sup_eq;}
"<=" {strcpy(yylval.keyW,yytext);return key_inf_eq;}
">" {strcpy(yylval.keyW,yytext);return key_sup;}
"<" {strcpy(yylval.keyW,yytext);return key_inf;}
"!=" {strcpy(yylval.keyW,yytext);return key_not_eq;}
"==" {strcpy(yylval.keyW,yytext);return key_is_eq;}

"&" {printf("%s",yytext);return key_and;}
"|" {printf("%s",yytext);return key_or;}

"=" {printf("%s",yytext);return key_eq;}

"VERIF" {printf("%s",yytext);return key_verif;}
"AUTRE" {printf("%s",yytext);return key_autre;}
"TANT QUE" {printf("%s",yytext);return key_tq;}

"(" {printf("%s",yytext);return key_par_open;}
")" {printf("%s",yytext);return key_par_close;}

" " {printf("%s",yytext);}

"," {printf("%s",yytext);return key_virg;}
";" {printf("%s",yytext);return key_point_virg;}


{idf} {   
  if(yyleng > 8){
    yyerror("Idf trop long");
    return 0;
  }
  ajouter(yytext);
  strcpy(yylval.idf,yytext);
  printf("%s",yylval.idf);
  return key_idf;
 }
{val_float} {
  if(atof(yytext) > 10000){
    yyerror("Nombre trop grand");
    return 0;
  }
  strcpy(yylval.v.value,yytext);
   strcpy(yylval.v.type,"FLOAT");
  //yylval.fn = atof(yytext);
  printf("float");
  return key_float;}
{val_natural} {
  if(atoi(yytext) > 10000){
    yyerror("Nombre trop grand");
    return 0;
  }
  strcpy(yylval.v.value,yytext);
  strcpy(yylval.v.type,"NATURAL");
  //yylval.natural = atoi(yytext);
  printf("natural");
  return key_natural;
}

{val_string} {printf("str");
  if(strlen(yytext) > 255){
    yyerror("Chaine de caractère trop grande");
    return 0;
  }
  strcpy(yylval.v.value,yytext);
  strcpy(yylval.v.type,"STRING");
  return key_string;}
. {printf("erreur caractère non reconnue a la ligne %d : \"%s\"",yylineno,yytext);}
%%

