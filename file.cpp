#include <fstream>
#include <iostream>
#include <vector>

#include "file.h"
#include "yylex.h"
#include "yyparse.h"

using namespace std;

token::token (int linenr) :linenr(linenr) {}

token::~token () {
   delete text;
}

func::func () {
   tokens = new vector<token*>;
}

func::~func () {
   delete tokens;
}

file::file () {
   contents = new vector<string>;
}

file::~file () {
   delete contents;
   delete file_name;
}

void file::open_yyin () const {
   string command = CPP + " " + *file_name;
   yyin = popen (command.c_str(), "r");
}

void file::flex_file () const {
   yyin = fopen (file_name->c_str(), "r");
   while (yylex()); // ;-)
   fclose (yyin);
}

void file::bison_file () const {
   yyin = fopen (file_name->c_str(), "r");
   int parse_rc = yyparse();
   if (parse_rc) 
      cerr << "parse failed with code: " << parse_rc << endl;
   fclose (yyin);
}

void file::get_contents () {
   string line;
   ifstream this_file;
   this_file.open (*file_name);
   while (getline (this_file, line)) {
      string* this_line = new string (line);
      contents->push_back (*this_line);
   }
   this_file.close();
}