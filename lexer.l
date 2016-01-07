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
EXTERN      ("extern")
VOLATILE    ("volatile")
POINTER     ('*')
ARRAY       ("[]")

QUALIFIERS  [CONST | STATIC | INLINE | VOLATILE | EXTERN]
TYPE        [INT | VOID | CHAR | DOUBLE | FLOAT | (LONG)+] 

%%

[ \t\n]        {}
{QUALIFIERS}   { RETURN (QUALIFIERS); }

{TYPE}         { printf ("type: %s\n", yytext); RETURN (TYPE); }

{STRUCT}       { printf ("struct: %s\n", yytext); RETURN (STRUCT); }

{POINTER}      { RETURN (POINTER); }

{ARRAY}        { RETURN (ARRAY); }

"{"            { RETURN ('{'); }
"}"            { RETURN ('}'); }
"("            { RETURN ('('); }
")"            { RETURN (')'); }
","            { RETURN (','); }

{ID}           { printf ("id: %s\n", yytext);  RETURN (ID); }

<<EOF>>        { return 0; }

.              {}

%%
