/* Adam Pinarbasi
 * TraceR
 */

#include <cstdlib>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

const string CPP = "/usr/bin/cpp";

static vector<string>* get_files (int argc, char** argv) {
   vector<string>* files = new vector<string>;
   for (int i = 1; i < argc; ++i) {
      string* filename = new string(argv[i]);
      files->push_back (*filename);
   }
   return files;
}

int main (int argc, char** argv) {
   vector<string>* files = get_files (argc, argv);
   for (size_t i = 0; i < files->size(); ++i) 
      cout << files->at(i) << endl; 
   delete files;
   return EXIT_SUCCESS;
}
