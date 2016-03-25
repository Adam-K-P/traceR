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
      void handle_header (const sp_func&, const std::string&, int);
      void add_content (const sp_func&, int);
      void handle_footer (const sp_func&, int);
      void fix_footer_ws (const sp_func&, int);

   public:
      void analyze ();
      analyzer ();
      ~analyzer ();
};

#endif
