module Veewee
  class Web

    require 'webrick'
    include WEBrick

    class FileServlet < WEBrick::HTTPServlet::AbstractServlet
             
              def initialize(server,localfile)
                super(server)
                @server=server
                @localfile=localfile
              end
             def do_GET(request,response)
                     response['Content-Type']='text/plain'
                     response.status = 200
                     
                     displayfile=File.open(@localfile,'r')
                     content=displayfile.read()
                     response.body=content
                     #If we shut too fast it might not get the complete file
                     sleep 2
                     @server.shutdown
             end
     end 

    def self.wait_for_request(filename,options={:timeout => 10, :web_dir => "", :port => 7125})  
      
      web_dir=options[:web_dir]
      filename=filename
      s= HTTPServer.new(:Port => options[:port])
      s.mount("/#{filename}", FileServlet,File.join(web_dir,filename))
      trap("INT"){
          s.shutdown
          exit
        }
      s.start
    end
    
  end
end