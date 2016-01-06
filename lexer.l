%{

%}

%option 8bit
%option noyywrap
%option nodefault
%option noinput
%option nounput
%option verbose
%option warn

LETTER [A-Za-z_]

%%

[ \t\n]  {}

{LETTER} { printf ("yahoo\n"); }

. { printf ("yoooo\n"); }

%%
