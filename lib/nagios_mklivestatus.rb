# This module holds the definition of the class used to query Nagios MkLiveStatus
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2011 GIP RECIA
# License::   General Public Licence
module Nagios
  # This class is used to create and querying a socket
  # It accepts the following socket:
  # * TCP : new("tcp://<host>:<port>")
  # * Unix : new("/var/lib/nagios/rw/live") 
  #
  # Author::    Esco-lan Team  (mailto:team@esco-lan.org)
  # Copyright:: Copyright (c) 2011 GIP RECIA
  # License::   General Public Licence
  class MkLiveStatus
    
    require File.dirname(__FILE__)+'/nagios_mklivestatus/query'
    require 'socket'
    
    # path informations of nagios sockets
    @mk_livestatus_socket_path=""
    
    # type of the socket
    @mk_livestatus_socket_type=""
    
    #debug mode : default to false
    @debug = false
  
    # Initialize the nagios mklivestatus socket informations.
    #
    # Two type of socket are supported for now:
    # * TCP : path equal to "tcp://<host>:<port>"
    # * File : where path is the path to the file
    #
    # If debug is set to true it will indicates the information used for the socket 
    # and the query and result of each queries call
    def initialize(path,debug=false)
      
      #set debug mode
      if debug
        @debug = true
      end
      
      puts ""
      #check socket type
      # if the path start with tcp:// => tcp socket
      if path.strip.start_with?("tcp://")
        tmp = path[6,path.length]
        table = tmp.partition(":")
        @mk_livestatus_socket_type = "tcp"
        @mk_livestatus_socket_path = Hash.new
        @mk_livestatus_socket_path[:ip] = table[0]
        @mk_livestatus_socket_path[:port] = table[2]
        
        puts "type : "+@mk_livestatus_socket_type if @debug
        puts "ip : "+@mk_livestatus_socket_path[:ip] if @debug
        puts "port : "+@mk_livestatus_socket_path[:port] if @debug
      # default socket type is set to file
      elsif File.exists? path
        @mk_livestatus_socket_path = path
        @mk_livestatus_socket_type = "file"
        
        puts "type : "+@mk_livestatus_socket_type if @debug
        puts "file : "+@mk_livestatus_socket_path if @debug
      end
    end
    
    # The method opens the socket and send the query then return the response of nagios
    # 
    # The query parameter must be set and be a string reprensting the MKLiveStatus Query :
    #  GET hosts
    # or
    #  GET hosts
    #  Columns: host_name
    #  Filter: host_name ~ test
    #  ....
    #
    def query(query=nil)
      
      socket=nil
      
      puts ""
      #open socket depending on the type of connection
      case @mk_livestatus_socket_type
        when "tcp"
          socket=TCPSocket.open(@mk_livestatus_socket_path[:ip], @mk_livestatus_socket_path[:port])
          puts "Ouverture du socket TCP : "+@mk_livestatus_socket_path[:ip]+" "+@mk_livestatus_socket_path[:port] if @debug
        when "file"
          socket=UNIXSocket.open(@mk_livestatus_socket_path)
          puts "Ouverture du socket Unix : "+@mk_livestatus_socket_path if @debug
      end
      
      #if socket is generated and query exists
      if socket != nil and query != nil and query.to_s.upcase.start_with?("GET ")
        
        strQuery = query.to_s 
        #the endline must be empty
        if not strQuery.end_with?("\n")
          strQuery << "\n"
        end
        
        puts ""
        puts "---" if @debug
        puts strQuery if @debug
        puts "---" if @debug
        
        # set response header to 16
        strQuery << "ResponseHeader: fixed16\n"
        
        # query the socket
        socket.puts strQuery
        
        # close the socket
        socket.shutdown(Socket::SHUT_WR)
        
        # check data reception
        recieving = socket.recv(16)
        check_receiving_error recieving
        
        # get all the line of the socket
        response = ""
        while(line = socket.gets) do
          response << line
        end
        
        puts response if @debug
        
        return response
        
      end
      
    end
    
private
    # Check if the recived datas have a status code greater than 200.
    # If the case is matched then we raise an exception in order to stop the process
    #
    # datas : from socket.recv
    def check_receiving_error( datas )
      error_code = datas.split(" ")[0].to_i
      if error_code > 200
        raise Exception, "Nagios::MkLiveStatus.query return an error_code #{error_code}"
      end
    end  

  end
end