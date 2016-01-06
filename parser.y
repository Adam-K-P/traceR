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

%token LETTER
%start start

%%

start : program  {printf ("come onnnn\n"); }
      ;

program : program LETTER { printf ("inside of Bison\n"); }
        |
        ;

%%

void yyerror (const char* error) {
  fprintf (stderr, "%s\n", error);
}







