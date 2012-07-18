class Ruhoh
  module Parsers
    module Routes

      def self.generate
        routes = {}
        Ruhoh::DB.pages.each_value { |page|
          routes[page['url']] = page['id'] 
        }

        Ruhoh::DB.posts['dictionary'].each_value { |page|
          routes[page['url']] = page['id'] 
        }
        
        Ruhoh::DB.media.each { |k, v|
          routes[k] = v
          print k, v, "\n"
        }
        
        routes
      end
    
    end #Routes
  end #Parsers
end #Ruhoh