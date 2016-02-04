#ifndef __FILE_H
#define __FILE_H

#include <string>
#include <unordered_map>
#include <vector>

struct token {
   char* text;
   bool print_header; //whether to print out start macro after this token
   bool print_footer; //whether to print out exit macro after this token

   token (char*);
   ~token ();

   token* add (token*);
};

struct function {
   char* name;
   std::vector<token*>* tokens;
   bool is_void; //whether the return type of the function is void

   function ();
   ~function ();
};

struct file {
   std::string* file_name;

   file ();
   ~file ();

   void open_yyin () const;
   void bison_file () const;
   void print_to_file () const; 
   void print_contents_to_file () const;
};

extern std::vector<token*>* contents;
extern std::vector<function*>* functions;

#define YYSTYPE token*

#endif
