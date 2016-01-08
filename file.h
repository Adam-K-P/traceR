#ifndef __FILE_H
#define __FILE_H

#include <string>
#include <vector>

const std::string CPP = "/usr/bin/cpp";

struct token {
   char* text;
   int linenr;

   token (int);
   ~token ();
};

struct func { 
   std::vector<token*>* tokens;

   func ();
   ~func ();
};

struct file {
   int linenr;
   std::string* file_name;
   std::vector<std::string>* contents;
   std::vector<func*>* functions;

   file ();
   ~file ();

   void open_yyin () const;
   void flex_file () const;
   void bison_file () const;
   void get_contents ();
};

#endif
