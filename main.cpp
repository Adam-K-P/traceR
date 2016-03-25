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

static void usage () {
   cout << "Usage: traceR [file]" << endl;
   exit (EXIT_FAILURE);
}

int main (int argc, char** argv) {
   if (argc != 2) 
      usage ();
   up_file this_file = up_file (new file);
   this_file->file_name = up_string (new string (argv[1]));
   this_file->bison_file ();
   this_file->analyze ();
   return EXIT_SUCCESS;
}
