#ifndef __FILE_H
#define __FILE_H

#include <string>
#include <vector>

const std::string CPP = "/usr/bin/cpp";

struct file {
   std::string* file_name;
   std::vector<std::string>* contents;

   file ();
   ~file ();

   void open_yyin () const;
   void flex_file () const;
   void bison_file () const;
   void write_contents ();
};

#endif
