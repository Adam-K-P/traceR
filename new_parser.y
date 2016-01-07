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
        | program non_function
        |
        ;

function : TYPE ID { printf ("inside function\n"); }

non_function : LETTER
             | NUMBER
             | ID 
             | INT
             | VOID
             | CHAR
             | DOUBLE
             | FLOAT
             | LONG
             | STRUCT
             | CONST
             | STATIC
             | INLINE
             | VOLATILE
             | EXTERN 
             | POINTER
             | ARRAY
             | QUALIFIERS
             | TYPE
             | '{'
             | '}'
             | '('
             | ')'
             | ','
             ;
