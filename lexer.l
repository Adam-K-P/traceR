%{
#include <iostream>
#include "file.h"
#include "yyparse.h"

extern token* yylval;

#define RETURN(SYMBOL) do { \
   yylval = new token (yytext); \
   return SYMBOL; \
} while(0)

using namespace std;

/* Whitespace added to every token to simplify printing them */

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
WS          [ \t\n] 

QUALIFIER   ({CONST}|{STATIC}|{INLINE}|{VOLATILE}|{EXTERN})
TYPE        ({INT}|{VOID}|{CHAR}|{DOUBLE}|{FLOAT}|{LONG})

%%

{NUMBER}{WS}*       { RETURN (NUMBER); }

{QUALIFIER}{WS}*    { RETURN (QUALIFIER); }

{TYPE}{WS}*         { RETURN (TYPE); }

{STRUCT}{WS}*       { RETURN (STRUCT); }

{POINTER}{WS}*      { RETURN (POINTER); }

{ARRAY}{WS}*        { RETURN (ARRAY); }

{ID}{WS}*           { RETURN (ID); }

";"{WS}*            { RETURN (';'); }
":"{WS}*            { RETURN (':'); }
"<"{WS}*            { RETURN ('<'); }
">"{WS}*            { RETURN ('>'); }
"!"{WS}*            { RETURN ('!'); }
"@"{WS}*            { RETURN ('@'); }
"#"{WS}*            { RETURN ('#'); }
"$"{WS}*            { RETURN ('$'); }
"%"{WS}*            { RETURN ('%'); }
"^"{WS}*            { RETURN ('^'); }
"&"{WS}*            { RETURN ('&'); }
"-"{WS}*            { RETURN ('-'); }
"+"{WS}*            { RETURN ('+'); }
"/"{WS}*            { RETURN ('/'); }
"\\"{WS}*           { RETURN ('\\');}
"="{WS}*            { RETURN ('='); }
"?"{WS}*            { RETURN ('?'); }
"."{WS}*            { RETURN ('.'); }
"{"{WS}*            { RETURN ('{'); }
"}"{WS}*            { RETURN ('}'); }
"("{WS}*            { RETURN ('('); }
")"{WS}*            { RETURN (')'); }
"["{WS}*            { RETURN ('['); }
"]"{WS}*            { RETURN (']'); }
"\""{WS}*           { RETURN ('"'); } /* caution here */
","{WS}*            { RETURN (','); }

<<EOF>>        { return 0; }

.              { }

%%
