#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <vector>

#include "file.h"
#include "yylex.h"
#include "yyparse.h"

using namespace std;

std::vector<token*>* contents;

token::token (char* this_text) { 
   text = strdup(this_text);
}

token::~token () {
   free (text);
}

token* token::add (token* that_tok) {
   string this_str(text);
   string that_str(that_tok->text);
   string the_str(this_str + that_str);
   token* the_tok = new token((char*)the_str.c_str());
   delete this;
   delete that_tok;
   return the_tok;
}

file::file () {
   contents = new vector<token*>;
}

file::~file () {
   vector<token*>* temp = contents;
   contents = nullptr;
   delete temp;
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
      cout  << contents->at(i)->text;
}




