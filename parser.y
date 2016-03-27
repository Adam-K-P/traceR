%{
#include <cctype>
#include <iostream>
#include <string>
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
%expect 2

%token NUMBER ID STRUCT RETURN
       POINTER ARRAY QUALIFIER  
       INT VOID CHAR DOUBLE FLOAT LONG COMMENT
       '{' '}' '(' ')' ',' '#' ';' 

%start start

%%

start : program 
      ;

program : program function     { } 
        | program return       { } 
        | program error        { contents->push_back ($2); 
                                 yyclearin; // squashed the bug ;-)
                               }
        | program COMMENT      { contents->push_back ($2); }
        |                      { }
        ;

return : RETURN ID             { contents->push_back ($1); 
                                 contents->push_back ($2);
                                 $1->print_footer = true;
                               }
       | RETURN error          { contents->push_back ($1);
                                 contents->push_back ($2);
                                 yyclearin;
                                 $1->print_footer = true;
                               }
       | RETURN                { contents->push_back ($1);
                                 $1->print_footer = true;
                               }
       ;

new_function : idseq new_params '{'  
                                     { cout << "matched new_function" << endl;
                                       $3->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                 
                                       sp_func this_func = sp_func (new func);
                                       this_func->tokens->push_back ($1);
                                       this_func->tokens->push_back ($2);
                                       this_func->tokens->push_back ($3);
                                       this_func->name = up_string 
                                                         (new string ("yo"));
                                       functions->push (this_func);
                                     }
         ;

idseq : ID ID idseq_ { $1->func_begin = true;
                       $$ = $1->add ($2);
                       $$ = $$->add ($3);
                     }
      | ID ID        { $1->func_begin = true;
                       $$ = $1->add ($2); 
                     }

      ;

idseq_ : idseq_ ID   { $$ = $$->add ($2); }
       | ID          { $$ = $1; }
       ;

new_params : '(' paramlist ')' { $$ = $1->add ($2);
                                 $$ = $$->add ($3);
                               }
           | '(' ')'           { $$ = $1->add ($2); }
           ;

paramlist : paramlist ',' idseq { $$ = $$->add ($2);
                                  $$ = $$->add ($3);
                                }
          | idseq               { $$ = $1; }
          ;

function : quals type ID params '{'
                                     { $1->func_begin = true;
                                       $5->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       contents->push_back ($5);

                                       sp_func this_func = sp_func (new func);
                                       this_func->tokens->push_back ($1);
                                       this_func->tokens->push_back ($2);
                                       this_func->tokens->push_back ($3);
                                       this_func->tokens->push_back ($4);
                                       this_func->tokens->push_back ($5);
                                       this_func->name = up_string 
                                                         (new string 
                                                            (*($3->text)));
                                       functions->push (this_func);
                                     }
         | type ID params '{'        { $1->func_begin = true;
                                       $4->print_header = true;
                                       contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);

                                       sp_func this_func = sp_func (new func);
                                       if ($1->void_func) 
                                          this_func->is_void = true;
                                       this_func->tokens->push_back ($1);
                                       this_func->tokens->push_back ($2);
                                       this_func->tokens->push_back ($3);
                                       this_func->tokens->push_back ($4);
                                       this_func->name = up_string 
                                                         (new string 
                                                            (*($2->text)));
                                       functions->push (this_func);
                                     }
         | quals type error          { contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);  
                                       yyclearin;
                                     }
         | quals type ID error       { contents->push_back ($1);
                                       contents->push_back ($2);
                                       contents->push_back ($3);
                                       contents->push_back ($4);
                                       yyclearin;
                                     }
         | type error                { contents->push_back ($1);
                                       contents->push_back ($2);
                                       yyclearin; 
                                     }
         | type ID error             { contents->push_back ($1);
                                       contents->push_back ($2); 
                                       contents->push_back ($3);
                                       yyclearin;
                                     }
         ;

type: INT      { $$ = $1; }
    | VOID     { $1->void_func = true; $$ = $1; }
    | CHAR     { $$ = $1; }
    | DOUBLE   { $$ = $1; }
    | FLOAT    { $$ = $1; }
    | LONG     { $$ = $1; }
    | ID       { $$ = $1; }
    ;

quals : quals QUALIFIER    { $$ = $$->add ($2); }
      | QUALIFIER          { $$ = $1; }
      ;

params : '(' decls ')' { $$ = $1->add ($2);
                         $$ = $$->add ($3);
                       }
       | '(' ')'       { $$ = $1->add ($2); 
                       }
       ;

decls : decls ',' decl { $$ = $$->add ($2);
                         $$ = $$->add ($3);
                       }
      | decl           { $$ = $1; 
                       }
      ;

decl : type ID         { $$ = $1->add ($2); /* treating as a single token */
                       } 
     | VOID            { $$ = $1; 
                       }
     ;

%%

/* Don't want to report errors */
void yyerror (const char* error) { 
   (void) error; 
}
   
