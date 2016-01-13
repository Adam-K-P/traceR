%{
#include <cstdio>
#include "file.h"
#include "yyparse.h"

extern token* yylval;

#define RETURN(SYMBOL) do { \
   yylval = new token (yytext); \
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

LETTER      [A-Za-z_]
NUMBER      [0-9]
ID          ({LETTER}({LETTER}|{NUMBER})*)
INT         "int"
VOID        "void"
CHAR        "char"
DOUBLE      "double"
FLOAT       "float"
LONG        "long"
STRUCT      "struct"
CONST       "const"
STATIC      "static"
INLINE      "inline"
EXTERN      "extern"
VOLATILE    "volatile"
POINTER     ('*')+
ARRAY       "[]"

QUALIFIER   ({CONST}|{STATIC}|{INLINE}|{VOLATILE}|{EXTERN})
TYPE        ({INT}|{VOID}|{CHAR}|{DOUBLE}|{FLOAT}|{LONG})

%%

[ \t]          {}
"\n"           { return '\n'; }

{QUALIFIER}    { RETURN (QUALIFIER); }

{TYPE}         { RETURN (TYPE); }

{STRUCT}       { RETURN (STRUCT); }

{POINTER}      { RETURN (POINTER); }

{ARRAY}        { RETURN (ARRAY); }

"{"            { RETURN ('{'); }
"}"            { RETURN ('}'); }
"("            { RETURN ('('); }
")"            { RETURN (')'); }
","            { RETURN (','); }

{ID}           { RETURN (ID); }

<<EOF>>        { return 0; }

.              { }

%%
