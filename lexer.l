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

LETTER      [A-Za-z_]
NUMBER      [0-9]
ID          ({LETTER}({LETTER}|{NUMBER})*)
INT         ("int")
VOID        ("void")
CHAR        ("char")
DOUBLE      ("double")
FLOAT       ("float")
LONG        ("long")
STRUCT      ("struct")
CONST       ("const")
STATIC      ("static")
INLINE      ("inline")
VOLATILE    ("volatile")
POINTER     ('*')
ARRAY       ("[]")

QUALIFIER   [CONST | STATIC | INLINE | VOLATILE]
TYPE        [INT | VOID | CHAR | DOUBLE | FLOAT | LONG] 

%%

[ \t\n]        {}

{ID}           { RETURN (ID); }

{QUALIFIER}    { RETURN (QUALIFIER); }

{TYPE}         { RETURN (TYPE); }

{STRUCT}       { RETURN (STRUCT); }

{POINTER}      { RETURN (POINTER); }

{ARRAY}        { RETURN (ARRAY); }

"{"            { RETURN ('{'); }
"}"            { RETURN ('}'); }
"("            { RETURN ('('); }
")"            { RETURN (')'); }

<<EOF>>        { return 0; }

.              {}

%%
