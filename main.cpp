/* traceR
 * written Adam Pinarbasi
 */

#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#include "file.h"
#include "yylex.h"
#include "yyparse.h"

using namespace std;

static vector<file*>* create_files (int argc, char** argv) {
   vector<file*>* files = new vector<file*>;
   for (int i = 1; i < argc; ++i) {
      file* this_file = new file;
      this_file->file_name = new string(argv[i]);
      files->push_back (this_file);
   }
   return files;
}

int main (int argc, char** argv) {
   vector<file*>* files = create_files (argc, argv);
   for (size_t i = 0; i < files->size(); ++i) {
      //files->at(i)->bison_file();
      files->at(i)->flex_file();
      files->at(i)->display();
   }
   delete files;
   return EXIT_SUCCESS;
}
