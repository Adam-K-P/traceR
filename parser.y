%{
#include <cstdio>
#include "yylex.h"
#include "yyparse.h"

void yyerror (const char*);
%}

%debug
%defines
%error-verbose
%token-table
%verbose

%token LETTER NUMBER ID INT VOID CHAR DOUBLE FLOAT LONG STRUCT CONST
       STATIC INLINE VOLATILE EXTERN POINTER ARRAY QUALIFIERS TYPE
       '{' '}' '(' ')' ','
%start start

%%

start : program 
      ;

program : program function { printf ("found a function\n"); }
        |
        ;

function : QUALIFIERS TYPE ID params { printf ("inside function\n"); }
         ;

params : '(' decls ')' { printf ("reading params\n"); }
       | '(' ')'
       ;

decls : decls ',' decl { printf ("inside of decls\n"); }
      | decl           { printf ("inside of decls\n"); }
      ;

decl : TYPE ID { printf ("reading decl\n"); }
     ;

%%

void yyerror (const char* error) {
  fprintf (stderr, "%s\n", error);
}







