%{

#define YY_USER_ACTION { lexer::advance(); }

%}

LETTER [A-Za-z_]

%%

{LETTER} { cout << "hello world" << endl; }

%%
