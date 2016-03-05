#ifndef __FILE_H
#define __FILE_H

#include <queue>
#include <string>
#include <vector>

struct token {
   char* text;
   bool print_header; //whether to print out start macro after this token
   bool print_footer; //whether to print out exit macro after this token
   bool func_begin; //first token of a function
   bool void_func; //first token of void function

   token (char*);
   ~token ();

   token* add (token*);
};

struct func {
   char* name;
   std::vector<token*>* tokens;
   bool is_void; //whether the return type of the function is void
   std::string header_ws;
   bool footer_printed; //has footer already been printed

   func ();
   ~func ();
};

struct file {
   std::string* file_name;

   file ();
   ~file ();

   void open_yyin () const;
   void bison_file () const;
   void analyze () const;
};

//Need to be global for bison
extern std::vector<token*>* contents;
extern std::queue<func*>* functions;

#define YYSTYPE token*

#endif
