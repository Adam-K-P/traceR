#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <memory>
#include <queue>
#include <stack>
#include <string>
#include <vector>

#include "analyzer.h"
#include "file.h"
#include "yylex.h"
#include "yyparse.h"

using namespace std;

up_vec_tok contents;
up_que_func functions;

token::token (const char* this_text) { 
   print_footer = false;
   print_header = false;
   func_begin   = false;
   void_func    = false;
   text = up_string (new string (this_text));
}

token::~token () {}

sp_tok token::add (const sp_tok& that_tok) const {
   string this_str = *text + *(that_tok->text);
   sp_tok the_tok = sp_tok (new token(this_str.c_str ()));
   return the_tok;
}

func::func () {
   tokens = up_vec_tok (new vector<sp_tok>);
   header_ws = up_string (nullptr);
   name = up_string (nullptr);
   is_void = false;
   footer_printed = false;
}

func::~func () {}

file::file () {
   contents = up_vec_tok (new vector<sp_tok>);
   functions = up_que_func (new queue<sp_func>);
}

file::~file () {}

void file::bison_file () const {
   yyin = fopen (file_name->c_str(), "r");
   int parse_rc = yyparse();
   if (parse_rc) 
      cerr << "parse failed with code: " << parse_rc << endl;
   fclose (yyin);
}

void file::analyze () const {
   unique_ptr<analyzer> this_analyzer = unique_ptr<analyzer> (new analyzer);
   this_analyzer->analyze ();
}

