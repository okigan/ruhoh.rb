require 'pathname'

class Ruhoh
  module Parsers
    module Media
    
      def self.generate
        Ruhoh.ensure_setup
        
        results = self.process
      end
      
      def self.process
        dictionary = {}
  
        self.files.each do |filename|
          dictionary[filename] = self.compiled_path(filename)

        end
        
        print dictionary, "\n"

        dictionary
      end
      
      def self.files
        FileUtils.cd(Ruhoh.paths.base) {
          return Dir["#{Ruhoh.names.pages}/**/*.png"].select { |filename|
            print "media generate\n"
            true
          }
        }
      end
      
      def self.is_valid_page?(filepath)
        true
      end

    # Public: Formats the path to the compiled file based on the URL.
    #
    # Returns: [String] The relative path to the compiled file for this page.
    def self.compiled_path(path)
      first =  Pathname.new Ruhoh.names.pages
      second =  Pathname.new path

      print "first ", first, "\n"
      print "second ", second, "\n"

      r = second.relative_path_from first

      print "r ", r, "\n"

      r
    end
      
    end # Media
  end #Parsers
end #Ruhoh