require 'ruhoh/compilers/theme'
require 'ruhoh/compilers/rss'

class Ruhoh
  module Compiler

    # TODO: seems rather dangerous to delete the incoming target directory?
    def self.compile(target_directory = nil, page = nil)
      Ruhoh::Friend.say { plain "Compiling for environment: '#{Ruhoh.config.env}'" }
      target = target_directory || "./#{Ruhoh.names.compiled}"
      page = page || Ruhoh::Page.new
      
      FileUtils.rm_r target if File.exist?(target)
      FileUtils.mkdir_p target
      
      self.constants.each {|c|
        task = self.const_get(c)
        print c, "\n"
        next unless task.respond_to?(:run)
        task.run(target, page)

      }  
      true
    end
    
    module Defaults

      def self.run(target, page)
        self.pages(target, page)
        self.media(target, page)
      end
      
      def self.pages(target, page)
        FileUtils.cd(target) {
          Ruhoh::DB.all_pages.each_value do |p|
            page.change(p['id'])

            print p['id'], "---", page.compiled_path, "\n"

            FileUtils.mkdir_p File.dirname(page.compiled_path)
            File.open(page.compiled_path, 'w:UTF-8') { |p| p.puts page.render }

            Ruhoh::Friend.say { green "processed: #{p['id']}" }
          end
        }
      end
      
      def self.media(target, page)
        return unless FileTest.directory? Ruhoh.paths.media
       media = Ruhoh::Utils.url_to_path(Ruhoh.urls.media, target)
        FileUtils.mkdir_p media
        FileUtils.cp_r File.join(Ruhoh.paths.media, '.'), media

        print "length of media hash=", Ruhoh::DB.media.length, "\n"
        
        Ruhoh::DB.media.each do |k, v|
            print k, "----", v, "\n"
            FileUtils.mkdir_p File.dirname(File.join(target, v))
            FileUtils.cp File.join(Ruhoh.paths.base, k), File.join(target, v)
        end
      end
      
    end #Defaults

  end #Compiler
end #Ruhoh