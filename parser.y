%{
#include <iostream>
#include <vector>

#include "file.h"
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
       STATIC INLINE VOLATILE EXTERN POINTER ARRAY QUALIFIER TYPE
       '{' '}' '(' ')' ','

%start start

%%

start : program 
      ;

program : program function { cout << "function matched" << endl; }
        | program error    { contents->push_back ($2); }
        |
        ;

function : QUALIFIER TYPE ID params  { contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                     }
         | QUALIFIER QUALIFIER TYPE ID params
                                     { contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                     }
         | TYPE ID params            { contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                     }
         | QUALIFIER TYPE POINTER ID params
                                     { contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                     }
         | QUALIFIER QUALIFIER TYPE POINTER ID params
                                     { contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                       contents->push_back ($6);
                                     }
         | TYPE POINTER ID params    { contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                     }
         ;

params : '(' decls ')' { $$ = $1->add ($2);
                         $$ = $$->add ($3);
                       }
       | '(' ')'       { $$ = $1->add ($2); }
       ;

decls : decls ',' decl { contents->push_back ($2); }
      | decl           { }
      ;

decl : TYPE ID          { contents->push_back ($1);
                          contents->push_back ($2);
                        }
     | TYPE POINTER ID  { contents->push_back ($1);
                          contents->push_back ($2);
                          contents->push_back ($3);
                        }
     | VOID             { contents->push_back ($1); }
     | VOID POINTER     { contents->push_back ($1);
                          contents->push_back ($2);
                        }
     ;

%%

/* No need to report errors */
void yyerror (const char* error) {
   (void) error;
}

