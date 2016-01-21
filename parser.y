%{
#include <iostream>
#include <vector>

#include "file.h"
#include "yylex.h"
#include "yyparse.h"

void yyerror (const char*);

//#define debug 
#ifdef debug
#define error_mac do { \
   cout << "error: " << yytext << endl; \
} while (0)
#else 
#define error_mac
#endif

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

program : program function '}' { $3->print_footer = true; }
        | program error        { error_mac; contents->push_back ($2); }
        |                      { }
        ;

function : QUALIFIER TYPE ID params '{' 
                                     { $5->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                     }
         | QUALIFIER QUALIFIER TYPE ID params '{'
                                     { $6->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                       contents->push_back ($6);
                                     }
         | TYPE ID params '{'        { $4->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                     }
         | QUALIFIER TYPE POINTER ID params '{'
                                     { $6->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                       contents->push_back ($6);
                                     }
         | QUALIFIER QUALIFIER TYPE POINTER ID params '{'
                                     { $7->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                       contents->push_back ($6);
                                       contents->push_back ($7);
                                     }
         | TYPE POINTER ID params '{'
                                     { $5->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                     }
         | TYPE ID error             { contents->push_back ($1);
                                       contents->push_back ($2);
                                     }
         | TYPE error                { contents->push_back ($1); }
         ;

params : '(' decls ')' { $$ = $1->add ($2);
                         $$ = $$->add ($3);
                       }
       | '(' ')'       { $$ = $1->add ($2); }
       ;

decls : decls ',' decl { $$ = $$->add ($2);
                         $$ = $$->add ($3);
                       }
      | decl           { $$ = $1; }
      ;

decl : TYPE ID         { $$ = $1->add ($2); } /* treating as a single token */
     | TYPE POINTER ID { $$ = $1->add ($2);
                         $$ = $$->add ($3);
                       }
     | VOID            { $$ = $1; }
     | VOID POINTER    { $$ = $1->add ($2); }
     ;

%%

/* No need to report errors */
void yyerror (const char* error) { 
   (void) error; 
   cout << "yyerror: " << yytext << endl;
}
   
