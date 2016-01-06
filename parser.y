%{
#include <cstdio>
#include "yylex.h"

void yyerror (const char*);
%}

%debug
%defines
%error-verbose
%token-table
%verbose

%token ROOT
%start start


%%

start : ROOT { printf ("program begin\n"); }
      ;

%%

void yyerror (const char* error) {
  fprintf (stderr, "%s\n", error);
}







