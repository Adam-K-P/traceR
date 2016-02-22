#ifndef __ANALYZER_H
#define __ANALYZER_H

#include <string>
#include <vector>

#include "file.h"

class analyzer {

   private:
      std::vector<std::string>* analyzed_contents;
      void add_file_prefix ();
      void analyze_contents ();
      void handle_header (function*, std::string, int);
      void handle_footer (function*, int);
      void fix_footer_ws (function*, int);

   public:
      void analyze ();
      analyzer ();
      ~analyzer ();
};

#endif
