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
//#define debug_function
//#define debug_params
//#define debug_decls
//#define debug_body

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

#ifdef debug_body
#define body_mac(BODY) do { \
   printf ("%s: %s", BODY, yytext); \
} while (0);
#else
#define body_mac
#endif //debug_body

using namespace std;
%}

%debug
%defines
%error-verbose
%token-table
%verbose

%token NUMBER ID VOID STRUCT RETURN
       POINTER ARRAY QUALIFIER TYPE 
       '{' '}' '(' ')' ',' '#' ';' 

%start start

%%

start : program 
      ;

program : program function     { } 
        | program return       { } 
        | program error        { error_mac; contents->push_back ($2); 
                                 yyclearin; // squashed the bug ;-)
                               }
        |                      { }
        ;

return : RETURN ID             { contents->push_back ($1); 
                                 contents->push_back ($2);
                                 $1->print_footer = true;
                               }
      | RETURN                 { contents->push_back ($1);
                                 $1->print_footer = true;
                               }
      ;

function : quals TYPE ID params '{'
                                     { function_mac 
                                          ("quals TYPE ID params");
                                       $1->func_begin = true;
                                       $5->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);

                                       function* this_func = new function();
                                       this_func->tokens->push_back ($1);
                                       this_func->tokens->push_back ($2);
                                       this_func->tokens->push_back ($3);
                                       this_func->tokens->push_back ($4);
                                       this_func->tokens->push_back ($5);
                                       this_func->name = $3->text;
                                       functions->push (this_func);
                                     }
         | TYPE ID params '{'       { function_mac ("TYPE ID params");
                                       $1->func_begin = true;
                                       $4->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);

                                       function* this_func = new function();
                                       if ($1->void_func) {
                                          cout << "omg ... again" << endl;
                                          this_func->is_void = true;
                                       }
                                       this_func->tokens->push_back ($1);
                                       this_func->tokens->push_back ($2);
                                       this_func->tokens->push_back ($3);
                                       this_func->tokens->push_back ($4);
                                       this_func->name = $2->text;
                                       functions->push (this_func);
                                     }
         | quals TYPE error          { function_mac ("quals TYPE error");
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);  
                                       yyclearin;
                                     }
         | quals TYPE ID error       { function_mac ("quals TYPE ID error");
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       yyclearin;
                                     }
         | TYPE error                { function_mac ("TYPE error"); 
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       yyclearin; 
                                     }
         | TYPE ID error             { function_mac ("TYPE ID error"); 
                                       contents->push_back ($1);
                                       contents->push_back ($2); 
                                       contents->push_back ($3);
                                       yyclearin;
                                     }
         ;

type : TYPE    { $$ = $1; }
     | VOID    { $$ = $1; }
     ;       

quals : quals QUALIFIER    { $$ = $$->add ($2); }
      | QUALIFIER          { $$ = $1; }
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
                         $1->void_func = true;
                         $$ = $1; 
                       }
     ;

%%

/* Don't want to report errors */
void yyerror (const char* error) { 
   (void) error; 
}
   
