%{
#include <iostream>
#include <vector>

#include "file.h"
#include "yylex.h"
#include "yyparse.h"

void yyerror (const char*);

/* Lots of debug macros below */

/* enable/disable debug macros here */
//#define debug_error
/*#define debug_function
#define debug_params
#define debug_decls*/

#ifdef debug_error

#define error_mac do { \
   cout << "error: " << yytext << endl; \
} while (0)

#else
#define error_mac
#endif //debug_error


#ifdef debug_function

#define function_mac(FUNCTION) do { \
   printf ("%s\n", FUNCTION);\
} while (0);

#else 
#define function_mac(FUNCTION)
#endif //debug_function


#ifdef debug_params

#define params_mac(PARAMS) do { \
   printf ("%s: %s\n", PARAMS, yytext); \
} while (0);

#else 
#define params_mac(PARAMS)
#endif //debug_params


#ifdef debug_decls

#define decls_mac(DECLS) do { \
   printf ("%s: %s\n", DECLS, yytext); \
} while (0);

#else
#define decls_mac(DECLS)
#endif //debug_decls

using namespace std;
%}

%debug
%defines
%error-verbose
%token-table
%verbose

%token NUMBER ID VOID STRUCT 
       POINTER ARRAY QUALIFIER TYPE 
       '{' '}' '(' ')' ',' '#'

%start start

%%

start : program 
      ;

program : program function     { }
        | program error        { error_mac; contents->push_back ($2); 
                                 yyclearin; // squashed the bug ;-)
                               }
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
                                       function_names->push_back ($3->text);
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
                                       function_names->push_back ($4->text);
                                     }
         | TYPE ID params '{'        { function_mac ("TYPE ID params");
                                       $4->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       function_names->push_back ($2->text);
                                     }
         | TYPE error                { function_mac ("TYPE error"); 
                                       contents->push_back ($1);
                                     }
         | TYPE ID error             { function_mac ("TYPE ID error"); 
                                       contents->push_back ($1);
                                       contents->push_back ($2);
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
     | VOID            { decls_mac ("VOID"); 
                         $$ = $1; 
                       }
     ;

%%

/* No need to report errors */
void yyerror (const char* error) { 
   (void) error; 
}
   
