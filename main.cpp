#include <cstdlib>
#include <fstream>
#include <iostream>
#include <memory>
#include <string>
#include <vector>

#include "file.h"
#include "yylex.h"
#include "yyparse.h"

using namespace std;

using up_file = unique_ptr<file>;
using up_vec_file = unique_ptr<vector<up_file>>;

static up_vec_file create_files (int argc, char** argv) {
   up_vec_file files = up_vec_file (new vector<up_file>);
   for (int i = 1; i < argc; ++i) {
      up_file this_file = up_file (new file);
      this_file->file_name = new string (argv[i]); 
      //^^^^^^this will need to be changed when file.cpp is updated
      files->push_back (move (this_file));
   }
   return files;
}

int main (int argc, char** argv) {
   up_vec_file files = create_files (argc, argv);
   for (size_t i = 0; i < files->size (); ++i) {
      files->at(i)->bison_file ();
      files->at(i)->analyze ();
   }
   return EXIT_SUCCESS;
}
