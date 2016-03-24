#ifndef __FILE_H
#define __FILE_H

#include <memory>
#include <queue>
#include <string>
#include <vector>

struct token;
struct func;
struct file;

using up_string = std::unique_ptr<std::string>;

using sp_tok = std::shared_ptr<token>;
using sp_func = std::shared_ptr<func>;
using up_file = std::unique_ptr<file>;

using up_vec_file = std::unique_ptr<std::vector<up_file>>;
using up_que_func = std::unique_ptr<std::queue<sp_func>>;
using up_vec_tok = std::unique_ptr<std::vector<sp_tok>>;

struct token {
   char* text;
   bool print_header; //whether to print out start macro after this token
   bool print_footer; //whether to print out exit macro after this token
   bool func_begin; //first token of a function
   bool void_func; //first token of void function

   token (const char*);
   ~token ();

   sp_tok add (const sp_tok&) const;
};

struct func {
   char* name;
   up_vec_tok tokens;
   //std::vector<token*>* tokens;
   bool is_void; //whether the return type of the function is void
   up_string header_ws;
   bool footer_printed; //has footer already been printed

   func ();
   ~func ();
};

struct file {
   up_string file_name;

   file ();
   ~file ();

   void open_yyin () const;
   void bison_file () const;
   void analyze () const;
};

//Need to be global for bison
extern up_vec_tok contents;
extern up_que_func functions;

#define YYSTYPE sp_tok 

#endif
