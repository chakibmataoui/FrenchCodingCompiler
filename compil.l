%{
#include <stdio.h>
#include "compil.tab.h"
#include "compil.h"
  extern int yyline;
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

"NATURAL" {printf("%s",yytext);return key_natural_dec;}
"FLOAT" {printf("%s",yytext);return key_float_dec;}
"STRING" {printf("%s",yytext);return key_str_dec;}

"+" {printf("%s",yytext);return key_plus;}
"-" {printf("%s",yytext);return key_minus;}
"*" {printf("%s",yytext);return key_mult;}
"/" {printf("%s",yytext);return key_div;}

">=" {printf("%s",yytext);return key_sup_eq;}
"<=" {printf("%s",yytext);return key_inf_eq;}
">" {printf("%s",yytext);return key_sup;}
"<" {printf("%s",yytext);return key_inf;}
"!=" {printf("%s",yytext);return key_not_eq;}
"==" {printf("%s",yytext);return key_is_eq;}

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
    //yyerror("Idf trop long");
    return 0;
  }
  ajouter(yytext);
  printf("idf");
  return key_idf;
 }
{val_float} {
if(atoi(yytext) > 1000){
yyerror("Nombre trop grand");
return 0;
}
printf("float");
  return key_float;}
{val_natural} {
if(atoi(yytext) > 1000){
yyerror("Nombre trop grand");
return 0;
}
  printf("natural");
  return key_natural;
}

{val_string} {printf("str");
  return key_string;}
. {printf("erreur caractère non reconnue a la ligne %d : \"%s\"",yylineno,yytext);}
%%

