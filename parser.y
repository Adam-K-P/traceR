%{
#include <iostream>

#include "yylex.h"
#include "yyparse.h"

void yyerror (const char*);

using namespace std;
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

program : program function { cout << "program completed" << endl; }
        | program error
        |
        ;

function : QUALIFIERS TYPE ID params 
                                     { cout << "matched function" << endl; }
         | QUALIFIERS QUALIFIERS TYPE ID params
                                     { cout << "matched function" << endl; }
         | TYPE ID params            { cout << "matched function" << endl; }
         | QUALIFIERS TYPE POINTER ID params
                                     { cout << "matched function" << endl; }
         | QUALIFIERS QUALIFIERS TYPE POINTER ID params
                                     { cout << "matched function" << endl; }
         | TYPE POINTER ID params    { cout << "matched function" << endl; }

         ;

params : '(' decls ')' { cout << "matched params" << endl; }
       | '(' ')'       { cout << "matched empty params" << endl; }
       ;

decls : decls ',' decl { cout << "matched decls" << endl; }
      | decl           { cout << "matched decl" << endl; }
      ;

decl : TYPE ID          { cout << "matched TYPE ID" << endl; }
     | TYPE POINTER ID  { cout << "matched TYPE ID" << endl; }
     | VOID             { cout << "matched VOID" << endl; }
     | VOID POINTER     { cout << "matched VOID pointer" << endl; }
     ;

%%

/* No need to report errors */
void yyerror (const char* error) {
   (void) error;
}

