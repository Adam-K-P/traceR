%{
#include <iostream>
#include <vector>

#include "file.h"
#include "yylex.h"
#include "yyparse.h"

void yyerror (const char*);

//#define debug_error
#ifdef debug_error

#define error_mac do { \
   cout << "error: " << yytext << endl; \
} while (0)

#else
#define error_mac
#endif //debug_error


#define debug_function
#ifdef debug_function

#define function_mac(FUNCTION) do { \
   printf ("%s\n", FUNCTION);\
} while (0);

#else 
#define function_mac(FUNCTION)
#endif //debug_function


#define debug_params
#ifdef debug_params

#define params_mac(PARAMS) do { \
   printf ("%s\n", PARAMS); \
} while (0);

#else 
#define params_mac(PARAMS)
#endif //debug_params


#define debug_decls
#ifdef debug_decls

#define decls_mac(DECLS) do { \
   printf ("%s\n", DECLS); \
} while (0);

#else
#define decls_mac (DECLS)
#endif //debug_decls

using namespace std;
%}

%debug
%defines
%error-verbose
%token-table
%verbose

%token LETTER NUMBER ID INT VOID CHAR DOUBLE FLOAT LONG STRUCT CONST
       STATIC INLINE VOLATILE EXTERN POINTER ARRAY QUALIFIER TYPE TYPEM
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
                                     { function_mac 
                                          ( "QUALIFIER TYPE ID params");
                                       $5->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                     }
         | QUALIFIER QUALIFIER TYPE ID params '{'
                                     { function_mac ( "QUALIFIER QUALIFIER\
                                                       TYPE ID params");
                                       $6->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                       contents->push_back ($6);
                                     }
         | TYPE ID params '{'        { function_mac ("TYPE ID params");
                                       cout << "TYPE ID params" << endl;
                                       $4->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                     }
         | QUALIFIER TYPE POINTER ID params '{'
                                     { function_mac 
                                          ("QUALIFIER TYPE POINTER ID params");
                                       $6->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                       contents->push_back ($6);
                                     }
         | QUALIFIER QUALIFIER TYPE POINTER ID params '{'
                                     { function_mac ("QUALIFIER QUALIFIER\
                                                      TYPE POINTER ID params");
                                       $7->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                       contents->push_back ($6);
                                       contents->push_back ($7);
                                     }
         | TYPE POINTER ID params '{'
                                     { function_mac ("TYPE POINTER ID params");
                                       $5->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);
                                     }
         ;

params : '(' decls ')' { params_mac ("params with decls");
                         $$ = $1->add ($2);
                         $$ = $$->add ($3);
                       }
       | '(' ')'       { params_mac ("params no decls");
                         $$ = $1->add ($2); 
                       }
       ;

decls : decls ',' decl { decls_mac ("matching decls");
                         $$ = $$->add ($2);
                         $$ = $$->add ($3);
                       }
      | decl           { decls_mac ("matching decl");
                         $$ = $1; 
                       }
      ;

decl : TYPE ID         { decls_mac ("TYPE ID");
                         $$ = $1->add ($2); /* treating as a single token */
                       } 
     | TYPE POINTER ID { decls_mac ("TYPE POINTER ID");
                         $$ = $1->add ($2);
                         $$ = $$->add ($3);
                       }
     | VOID            { decls_mac ("VOID"); 
                         $$ = $1; 
                       }
     | VOID POINTER    { decls_mac ("VOID POINTER");
                         $$ = $1->add ($2); 
                       }
     ;

%%

/* No need to report errors */
void yyerror (const char* error) { 
   (void) error; 
   cout << "yyerror: " << yytext << endl;
}
   
