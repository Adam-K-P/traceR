#include <cstdlib>
#include <fstream>
#include <iostream>
#include <vector>

#include "file.h"
#include "yylex.h"
#include "yyparse.h"

using namespace std;

token::token (char* this_text) { 
   text = strdup(this_text);
}

token::~token () {
   free (text);
}

file::file () {
   contents = new vector<token*>;
}

file::~file () {
   delete contents;
   delete file_name;
}

void file::open_yyin () const {
   string command = CPP + " " + *file_name;
   yyin = popen (command.c_str(), "r");
}

void file::flex_file () const {
   yyin = fopen (file_name->c_str(), "r");
   for (int index = 0;;++index) {
      int yyret = yylex();
      if (not yyret) 
         break;
      token* this_token = new token (yytext);
      contents->push_back (this_token);
   }
   fclose (yyin);
}

void file::bison_file () const {
   yyin = fopen (file_name->c_str(), "r");
   int parse_rc = yyparse();
   if (parse_rc) 
      cerr << "parse failed with code: " << parse_rc << endl;
   fclose (yyin);
}

void file::display () const {
   for (size_t i = 0; i < contents->size(); ++i) 
      cout  << contents->at(i)->text << endl;
}




