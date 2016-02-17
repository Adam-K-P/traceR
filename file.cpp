#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
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
queue<function*>* functions;

token::token (char* this_text) { 
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

/*******************************************************************************
 * EVERYTHING BELOW IS BEING MIGRATED TO ANALYZER MODULE
 *******************************************************************************
 */

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

//remove trailing whitespace
static void rm_trailing (char* text) {
   while (isspace (text[strlen (text) - 1]))
      text[strlen (text) - 1] = '\0';
}

static string handle_header (function* this_func, int i) {
   cout << contents->at(i)->text; //gotta print '{' out first
   rm_trailing (this_func->name); 
   printf ("enter_function (\"%s\");%s",
              this_func->name,
             (get_ws (contents->at(i)->text)).c_str());
   return get_ws (contents->at(i)->text);
}

static bool foot_func_check (function* this_func, int i) {
   if (contents->size() == (size_t)(i + 1)) //ensure not last index in contents
      return false; 
   //cout << "contents->at(i + 1)" << contents->at(i+ 1)->text << endl;
   if (contents->at(i + 1)->func_begin and this_func->is_void) 
      return true;
   return false;
}

static void handle_footer (function* this_func, vector<string> whitespace,
                           int i) {
   if (contents->at(i)->print_footer) 
      printf ("leave_function (\"%s\");%s", this_func->name,
                                            whitespace.at(i - 1).c_str());
   //TODO BELOW DOES NOT HAVE PROPER PRIOR WHITESPACE!!!
   //need a prev_prev_ws essentially
   else if (not strncmp (contents->at(i)->text, "}", 1) and
                foot_func_check (this_func, i)) {
      printf ("leave_function (\"%s\");%s", this_func->name,
                                            whitespace.at(i - 1).c_str());
   }
}

void file::print_contents_to_file () const {
   vector<string> whitespace;
   function* this_func;
   for (size_t i = 0; i < contents->size(); ++i) {
      if (contents->at(i)->func_begin) {
         this_func = functions->front();
         functions->pop();
      }

      if (contents->at(i)->print_header) {
         whitespace.push_back (handle_header (this_func, i));
         continue;
      }

      handle_footer (this_func, whitespace, i);
      cout << contents->at(i)->text;
      whitespace.push_back (get_ws (contents->at(i)->text));
   }
}

//TODO actually print to a file 
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

void file::analyze () const {
   analyzer* this_analyzer = new analyzer ();
   this_analyzer->analyze ();
}

