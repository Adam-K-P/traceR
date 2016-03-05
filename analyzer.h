#ifndef __ANALYZER_H
#define __ANALYZER_H

#include <memory>
#include <string>
#include <vector>

#include "file.h"

class analyzer {

   private:
      std::unique_ptr<std::vector<std::string>> analyzed_contents;
      void add_file_prefix ();
      void analyze_contents ();
      void handle_header (func*, std::string, int);
      void handle_footer (func*, int);
      void fix_footer_ws (func*, int);

   public:
      void analyze ();
      analyzer ();
      ~analyzer ();
};

#endif
