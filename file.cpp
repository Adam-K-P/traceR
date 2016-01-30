#include <cstdio>
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

//TODO actually print to file when it's ready
void file::print_to_file () const {
   //FILE* out_file = fopen (file_name->c_str(), "w");

   //TODO change to fprintf when ready
   printf (
"#define enter_function(FUNCTION_NAME) do {\\\n\
   printf(\"traceR: entering %%s\\n\", FUNCTION_NAME);\\\n\
} while (0);\n\n\
#define leave_function(FUNCTION_NAME) do {\\\n\
   printf(\"traceR: leaving %%s\\n\", FUNCTION_NAME);\\\n\
} while (0);\n\n" );

   for (size_t i = 0; i < contents->size(); ++i) {

      //fprintf (out_file, "%s", contents->at(i)->text);

      cout << contents->at(i)->text;
      if (contents->at(i)->print_header) 
         cout << endl << "ENTERING FUNCTION" << endl << endl;
      if (contents->at(i)->print_footer) 
         cout << endl << "EXITING FUNCTION" << endl << endl;
   }

   //fclose (out_file);
}




