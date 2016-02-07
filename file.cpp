#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <queue>
#include <stack>
#include <string>
#include <vector>

#include "file.h"
#include "yylex.h"
#include "yyparse.h"

using namespace std;

vector<token*>* contents;
queue<function*>* functions;

token::token (char* this_text) { 
   print_footer = false;
   print_header = false;
   func_begin   = false;
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

function::function () {
   tokens = new vector<token*>;
   is_void = false;
   name = NULL;
}

function::~function () {
   delete tokens;
   if (name != NULL)
      free (name);
}

file::file () {
   contents = new vector<token*>;
   functions = new queue<function*>;
}

/* dirty */
file::~file () {
   vector<token*>* temp = contents;
   contents = nullptr;
   delete temp;

   queue<function*>* temp2 = functions;
   functions = nullptr;
   delete temp2;

   delete file_name;
}

void file::bison_file () const {
   yyin = fopen (file_name->c_str(), "r");
   int parse_rc = yyparse();
   if (parse_rc) 
      cerr << "parse failed with code: " << parse_rc << endl;
   fclose (yyin);
}

/* Gets the trailing whitespace from a string
 * so that you can add it to the beginning of the
 * appropriate string */
static string get_ws (char* content) {
   string* ws = new string();
   stack<char> rev; //end up reversing whitespace string twice
   for (int i = strlen (content) - 1; i >= 0; --i) {
      if (isspace ((int)content[i])) 
         rev.push (content[i]);
      else break; 
   }
   while (not rev.empty()) {
      *ws += rev.top();
      rev.pop();
   }
   return *ws;
}

void file::print_contents_to_file () const {
   string prev_ws;
   for (size_t i = 0; i < contents->size(); ++i) {

      function* this_func;
      if (contents->at(i)->func_begin) {
         this_func = functions->front();
         functions->pop();
      }

      if (contents->at(i)->print_header) {
         cout << contents->at(i)->text;
         printf ("enter_function (\"%s\");%s", 
                     this_func->name,
                     (get_ws (contents->at(i)->text)).c_str());
         prev_ws = get_ws (contents->at(i)->text); //set before continuing
         continue; //already printed out this index's text
      }

      if (contents->at(i)->print_footer) 
         printf ("leave_function (\"%s\");%s", this_func->name, 
                                               prev_ws.c_str());

      cout << contents->at(i)->text;
      prev_ws = get_ws (contents->at(i)->text);
   }
}
   
//TODO actually print to file 
void file::print_to_file () const {
   //FILE* out_file = fopen (file_name->c_str(), "w");

   //TODO change to fprintf when ready
   //insert macros at top of file to simplify things
   printf (
"#define traceR //comment this line out to disable traceR\n\
#ifdef traceR\n\n\
#define enter_function(FUNCTION_NAME) do { \\\n\
   printf(\"traceR: entering %%s\\n\", FUNCTION_NAME); \\\n\
} while (0);\n\n\
#define leave_function(FUNCTION_NAME) do { \\\n\
   printf(\"traceR: leaving %%s\\n\", FUNCTION_NAME); \\\n\
} while (0);\n\n\
#else\n\n\
#define enter_function(FUNCTION_NAME)\n\
#define leave_function(FUNCTION_NAME)\n\n\
#endif //traceR\n\n");

   print_contents_to_file ();
}

