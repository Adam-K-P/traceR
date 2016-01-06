%{
#include <cstdio>
#include "yyparse.h"

extern int yylval;

#define RETURN(SYMBOL) do { \
   yylval = SYMBOL; \
   return SYMBOL; \
} while(0)

%}

%option 8bit
%option noyywrap
%option nodefault
%option noinput
%option nounput
%option verbose
%option warn

LETTER [A-Za-z_]

%%

[ \t\n]  {}

{LETTER} { printf ("eyyy\n"); RETURN (LETTER); }

. { return 0; }

%%
