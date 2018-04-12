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
val_string \'.\'
comment \$.*\n
%%
"MAIN" {printf("%s",yytext);}
"CODE" {printf("%s",yytext);}


"{" {printf("%s",yytext);}
"}" {printf("%s",yytext);}

{comment} {printf("%s",yytext);}

":" {printf("%s",yytext);}
"[" {printf("%s",yytext);}
"]" {printf("%s",yytext);}

"." {printf("%s",yytext);}

"\n" {printf("%s",yytext);yylineno++;}
"\t" {printf("%s",yytext);}

"NATURAL" {printf("%s",yytext);}
"FLOAT" {printf("%s",yytext);}
"STRING" {printf("%s",yytext);}

"+" {printf("%s",yytext);}
"-" {printf("%s",yytext);}
"*" {printf("%s",yytext);}
"/" {printf("%s",yytext);}

">=" {printf("%s",yytext);}
"<=" {printf("%s",yytext);}
">" {printf("%s",yytext);}
"<" {printf("%s",yytext);}
"!=" {printf("%s",yytext);}
"==" {printf("%s",yytext);}

"&" {printf("%s",yytext);}
"|" {printf("%s",yytext);}

"=" {printf("%s",yytext);}

"VERIF" {printf("%s",yytext);}
"AUTRE" {printf("%s",yytext);}
"TANT QUE" {printf("%s",yytext);}

"(" {printf("%s",yytext);}
")" {printf("%s",yytext);}

" " {printf("%s",yytext);}

"," {printf("%s",yytext);}
";" {printf("%s",yytext);}
"'" {printf("%s",yytext);}

{idf} {   
  if(yyleng > 8){
    //yyerror("Idf trop long");
    return 0;
  }
  printf("idf");
 }
{val_float} {printf("float");}
{val_natural} {
  printf("Number");
}

{val_string} {printf("str");}
. {printf("erreur : _____%s____",yytext);}
%%
int main(int argc,char**argv)
{
  yyin = fopen(argv[1],"r");
  yylex();
  printf("FIN ANALYSE \n");
  return 0;
}

int yywrap(){
  return 1;
  }
