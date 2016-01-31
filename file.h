#ifndef __FILE_H
#define __FILE_H

#include <string>
#include <unordered_map>
#include <vector>

const std::string CPP = "/usr/bin/cpp";

struct token {
   char* text;
   bool print_header; //whether to print out start macro after this token
   bool print_footer; //whether to print out exit macro after this token

   token (char*);
   ~token ();

   token* add (token*);
};

struct file {
   std::string* file_name;

   file ();
   ~file ();

   void open_yyin () const;
   void flex_file () const;
   void bison_file () const;
   void print_to_file () const; 
   void print_contents_to_file () const;
};

extern std::vector<token*>* contents;
extern std::vector<char*>* function_names;

#define YYSTYPE token*

#endif
