%{
#include <iostream>
#include "file.h"
#include "yyparse.h"

extern sp_tok yylval;

#define RETURN(SYMBOL) do { \
   yylval = sp_tok (new token (yytext)); \
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
ID          ({LETTER}|{NUMBER})+
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
RETURN      "return"
POINTER     "*"
ARRAY       "[]"
WS          [ \t\n] 

QUALIFIER   ({CONST}|{STATIC}|{INLINE}|{VOLATILE}|{EXTERN})

%%

{NUMBER}{WS}*                 { RETURN (NUMBER); }

{QUALIFIER}{WS}*              { RETURN (QUALIFIER); }

{INT}({POINTER}|{WS})*        { RETURN (INT); }

{VOID}({POINTER}|{WS})*       { RETURN (VOID); }

{CHAR}({POINTER}|{WS})*       { RETURN (CHAR); }

{DOUBLE}({POINTER}|{WS})*     { RETURN (DOUBLE); }

{FLOAT}({POINTER}|{WS})*      { RETURN (FLOAT); }

{LONG}({POINTER}|{WS})*       { RETURN (LONG); }

{STRUCT}{WS}*                 { RETURN (STRUCT); }

{ARRAY}{WS}*                  { RETURN (ARRAY); }

{RETURN}{WS}*                 { RETURN (RETURN); }

{ID}({POINTER}|{WS})*         { RETURN (ID); }

{POINTER}{WS}*                { RETURN (POINTER); }

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
'{WS}*              { RETURN ('\''); } /* yeah, totally not confusing ;-) */
"\""{WS}*           { RETURN ('"'); } /* caution here */
","{WS}*            { RETURN (','); }

<<EOF>>        { return 0; }

.              { }

%%
