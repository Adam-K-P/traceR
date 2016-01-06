/* traceR
 * written Adam Pinarbasi
 */

#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#include "yylex.h"
#include "yyparse.h"

using namespace std;

extern FILE* yyin;
extern int yylex();

const string CPP = "/usr/bin/cpp";

struct file {
   string* file_name;
   vector<string>* contents;

   file () {
      contents = new vector<string>;
   }
   ~file () {
      delete contents;
      delete file_name;
   }

   void flex_file () {
      yyin = fopen (file_name->c_str(), "r");
      while (yylex()); // ;-)
      fclose (yyin);
   }

   void bison_file () { //could possibly be declared static?
      yyin = fopen (file_name->c_str(), "r");
      int parse_rc = yyparse();
      if (parse_rc) 
         fprintf (stderr, "parse failed with code: %d\n", parse_rc);
      fclose (yyin);
   }

   void write_contents () {
      string line;
      ifstream this_file;
      this_file.open (*file_name);
      while (getline (this_file, line)) {
         string* this_line = new string (line);
         contents->push_back (*this_line);
      }
      this_file.close();
   }
};

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
      files->at(i)->write_contents();
      files->at(i)->bison_file();
   }
   delete files;
   return EXIT_SUCCESS;
}
