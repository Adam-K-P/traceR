#include <cstdio>
#include <cstring>
#include <iostream>
#include <memory>
#include <queue>
#include <stack>
#include <string>
#include <vector>

#include "analyzer.h"
#include "file.h"

using namespace std;

analyzer::analyzer () {
   analyzed_contents = unique_ptr<vector<string>> (new vector<string>);
}

analyzer::~analyzer () {}

/* Gets the trailing whitespace from a string
 * so that you can add it to the beginning of the
 * appropriate string */
static up_string get_ws (char* content) {
   string ws = "";
   stack<char> rev; //end up reversing whitespace string twice
   for (int i = strlen (content) - 1; i >= 0; --i) {
      if (isspace ((int)content[i])) 
         rev.push (content[i]);
      else break; 
   }
   while (not rev.empty()) {
      ws += rev.top();
      rev.pop();
   }
   up_string ws_ = up_string (new string (ws));
   return ws_;
}

//remove trailing whitespace
static void rm_trailing (char* text) {
   while (isspace (text[strlen (text) - 1]))
      text[strlen (text) - 1] = '\0';
}

void analyzer::handle_header (func* this_func, string content, int i) {
   vector<string>* analyzed_contents_ = analyzed_contents.get ();
   analyzed_contents_->push_back (content); //add '{' first
   rm_trailing (this_func->name);
   string func_name (this_func->name);
   up_string header_ws = get_ws (contents->at(i)->text);
   string analyzed_content = "enter_function (\"" + func_name + "\");"
                                                  + header_ws->c_str();
   this_func->header_ws = move (header_ws);
   analyzed_contents_->push_back (analyzed_content);
}

static bool foot_func_check (func* this_func, int i) {
   if (contents->size() == (size_t)(i + 1)) //ensure not last index in contents
      return false;
   if (contents->at(i + 1)->func_begin and this_func->is_void) 
      return true;
   return false;
}

//removes trailing whitespace
static void rm_trailing (string* text) {
   for (int i = text->size() - 1; isspace (text->at (i)); --i) 
      text->erase (text->begin () + i);
}

//just use same whitespace as the header does
void analyzer::fix_footer_ws (func* this_func, int i) {
   vector<string>* analyzed_contents_ = analyzed_contents.get ();
   rm_trailing (&(analyzed_contents_->at (i)));
   analyzed_contents_->at (i) += *(this_func->header_ws);
}

//TODO: ensure that there is always a function when referring to func_name
void analyzer::handle_footer (func* this_func, int i) {
   if (this_func->name == NULL) return; //this is not really a function
   if (contents->at(i)->print_footer) {
      string func_name (this_func->name);
      string analyzed_content = "leave_function (\"" + func_name + "\");"
                                + *(get_ws (contents->at(i - 1)->text));
      analyzed_contents->push_back (analyzed_content);
   }
   else if (not strncmp (contents->at(i)->text, "}", 1) and
                foot_func_check (this_func, i)) {
      string func_name (this_func->name);
      fix_footer_ws (this_func, analyzed_contents->size() - 1);
      string analyzed_content = "leave_function (\"" + func_name + "\");"
                                + *(get_ws (contents->at(i - 1)->text));
      analyzed_contents->push_back (analyzed_content);
   }
}

void analyzer::analyze_contents () {
   func* this_func;
   for (size_t i = 0; i < contents->size (); ++i) {
      string content (contents->at(i)->text);
      if (contents->at(i)->func_begin) {
         this_func = functions->front();
         functions->pop();
      }

      if (contents->at(i)->print_header) {
         handle_header (this_func, content, i);
         continue;
      }
      handle_footer (this_func, i);
      analyzed_contents.get()->push_back (content);
   }
}

void analyzer::add_file_prefix () {

   string prefix =
"#define traceR //comment this line out to disable traceR\n\
#ifdef traceR\n\n\
#define enter_function(FUNCTION_NAME) do { \\\n\
   printf(\"traceR: entering %s\\n\", FUNCTION_NAME); \\\n\
} while (0);\n\n\
#define leave_function(FUNCTION_NAME) do { \\\n\
   printf(\"traceR: leaving %s\\n\", FUNCTION_NAME); \\\n\
} while (0);\n\n\
#else\n\n\
#define enter_function(FUNCTION_NAME)\n\
#define leave_function(FUNCTION_NAME)\n\n\
#endif //traceR\n\n";

   analyzed_contents.get()->push_back (prefix);
}

void analyzer::analyze () {
   add_file_prefix ();
   analyze_contents ();
   for (size_t i = 0; i < analyzed_contents->size (); ++i) 
      cout << analyzed_contents->at (i);
}
