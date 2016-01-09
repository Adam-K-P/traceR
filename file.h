#ifndef __FILE_H
#define __FILE_H

#include <string>
#include <unordered_map>
#include <vector>

const std::string CPP = "/usr/bin/cpp";

struct token {
   char* text;
   bool print; //whether to print out macro after this token or not

   token (char*);
   ~token ();
};

struct file {
   std::string* file_name;
   std::vector<token*>* contents;

   file ();
   ~file ();

   void open_yyin () const;
   void flex_file () const;
   void bison_file () const;
   void display () const; // >:|
};

#endif
