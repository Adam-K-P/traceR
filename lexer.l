%{
#include <cstdio>
#include "file.h"
#include "yyparse.h"

extern token* yylval;

#define RETURN(SYMBOL) do { \
   yylval = new token (yytext); \
   return SYMBOL; \
} while(0)

using namespace std;

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

"\t"           { RETURN ('\t'); }
"\n"           { RETURN ('\n'); }

{NUMBER}       { RETURN (NUMBER); }

{QUALIFIER}    { RETURN (QUALIFIER); }

{TYPE}         { RETURN (TYPE); }

{STRUCT}       { RETURN (STRUCT); }

{POINTER}      { RETURN (POINTER); }

{ARRAY}        { RETURN (ARRAY); }

{ID}           { RETURN (ID); }

";"            { RETURN (';'); }
":"            { RETURN (':'); }
"<"            { RETURN ('<'); }
">"            { RETURN ('>'); }
"!"            { RETURN ('!'); }
"@"            { RETURN ('@'); }
"#"            { RETURN ('#'); }
"$"            { RETURN ('$'); }
"%"            { RETURN ('%'); }
"^"            { RETURN ('^'); }
"&"            { RETURN ('&'); }
"-"            { RETURN ('-'); }
"+"            { RETURN ('+'); }
"/"            { RETURN ('/'); }
"\\"           { RETURN ('\\');}
"="            { RETURN ('='); }
"?"            { RETURN ('?'); }
"."            { RETURN ('.'); }
"{"            { RETURN ('{'); }
"}"            { RETURN ('}'); }
"("            { RETURN ('('); }
")"            { RETURN (')'); }
"["            { RETURN ('['); }
"]"            { RETURN (']'); }
"\""           { RETURN ('"'); } /* caution here */
","            { RETURN (','); }

<<EOF>>        { return 0; }

.              { }

%%
