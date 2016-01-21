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
   print_footer = false;
   print_header = false;
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

file::file () {
   contents = new vector<token*>;
}

/* dirty */
file::~file () {
   vector<token*>* temp = contents;
   contents = nullptr;
   delete temp;
   delete file_name;
}

//is this function necessary???
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
   for (size_t i = 0; i < contents->size(); ++i) {
      cout  << contents->at(i)->text;
      if (contents->at(i)->print_header) 
         cout << endl << "ENTERING FUNCTION" << endl;
      if (contents->at(i)->print_footer) 
         cout << endl << "EXITING FUNCTION" << endl;
   }
}




