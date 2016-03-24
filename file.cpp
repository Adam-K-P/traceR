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

vector<token*>* contents;
up_que_func functions;

token::token (const char* this_text) { 
   print_footer = false;
   print_header = false;
   func_begin   = false;
   void_func    = false;
   text = strdup(this_text);
}

token::~token () {
   if (text != NULL)
      free (text);
}

token* token::add (token* that_tok) {
   string this_str(text);
   string that_str(that_tok->text);
   string the_str(this_str + that_str);
   token* the_tok = new token((char*)the_str.c_str());
   delete that_tok;
   return the_tok;
}

func::func () {
   tokens = new vector<token*>;
   is_void = false;
   header_ws = up_string (nullptr);
   name = NULL;
   footer_printed = false;
}

func::~func () {
   delete tokens;
   if (name != NULL)
      free (name);
}

file::file () {
   contents = new vector<token*>;
   functions = up_que_func (new queue<sp_func>);
}

file::~file () {
   vector<token*>* temp = contents;
   contents = nullptr;
   delete temp;
}

void file::bison_file () const {
   yyin = fopen (file_name->c_str(), "r");
   int parse_rc = yyparse();
   if (parse_rc) 
      cerr << "parse failed with code: " << parse_rc << endl;
   fclose (yyin);
}

void file::analyze () const {
   analyzer* this_analyzer = new analyzer ();
   this_analyzer->analyze ();
}

