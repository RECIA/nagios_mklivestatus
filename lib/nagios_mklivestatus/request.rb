##
# Request manager of the Nagios MkLivestatus
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Request
  
  require 'socket'
  
  include Nagios::MkLiveStatus
    
  # path informations of nagios sockets
  @mk_livestatus_socket_path=""
  
  # type of the socket
  @mk_livestatus_socket_type=""
  
  #user mode : default nil
  @user = nil
  
  #columns header mode
  @column_headers = false

  # Initialize the nagios mklivestatus socket informations.
  #
  # Two type of socket are supported for now:
  # * TCP : path equal to "tcp://<host>:<port>"
  # * File : where path is the path to the file
  #
  # The second parameter is a hash of options of MkLiveStatus :
  # * :user : is the user used with AuthUser of MkLiveStatus for hosts, services, hostgroups, servicegroup and log
  # * :column_headers : set to true to have the headers of the query as first line
  # 
  def initialize(path,options={})
    
    #set debug mode
    if options.has_key? :column_headers and options[:column_headers]
      @column_headers = true
    end
    
    #set user
    if options.has_key? :user and options[:user] != nil and not options[:user].empty?
      @user = options[:user]
    end
    
    #check socket type
    # if the path start with tcp:// => tcp socket
    if path.strip.start_with?("tcp://")
      tmp = path[6,path.length]
      table = tmp.partition(":")
      @mk_livestatus_socket_type = "tcp"
      @mk_livestatus_socket_path = Hash.new
      @mk_livestatus_socket_path[:ip] = table[0]
      @mk_livestatus_socket_path[:port] = table[2]
      
      puts "type : "+@mk_livestatus_socket_type if Nagios::MkLiveStatus::DEBUG
      puts "ip : "+@mk_livestatus_socket_path[:ip] if Nagios::MkLiveStatus::DEBUG
      puts "port : "+@mk_livestatus_socket_path[:port] if Nagios::MkLiveStatus::DEBUG
    # default socket type is set to file
    elsif File.exists? path
      @mk_livestatus_socket_path = path
      @mk_livestatus_socket_type = "file"
      
      puts "type : "+@mk_livestatus_socket_type if Nagios::MkLiveStatus::DEBUG
      puts "file : "+@mk_livestatus_socket_path if Nagios::MkLiveStatus::DEBUG
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
   
    puts "" if Nagios::MkLiveStatus::DEBUG
    
    #if socket is generated and query exists
    if query != nil and query.is_a? Nagios::MkLiveStatus::Query and query.to_s.upcase.start_with?("GET ")
      
      strQuery = "#{query}"
      #the endline must be empty
      if not strQuery.end_with?("\n")
        strQuery << "\n"
      end
      
      #set user if needed
      if @user != nil and not @user.empty? and strQuery.match /^GET\s+(hosts|hostgroups|services|servicegroup|log)\s*$/
        strQuery << "UserAuth: #{@user}\n"
      end
      
      # set columns headers
      if @column_headers
        strQuery << "ColumnHeaders: on\n"
      end
      
      puts "" if Nagios::MkLiveStatus::DEBUG
      puts "---" if Nagios::MkLiveStatus::DEBUG
      puts strQuery if Nagios::MkLiveStatus::DEBUG
      puts "---" if Nagios::MkLiveStatus::DEBUG
      
      #get error message if some are given
      strQuery << "ResponseHeader: fixed16\n"
      
      socket = open_socket()
      
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
      
      puts response if Nagios::MkLiveStatus::DEBUG
      
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
      raise RequestException, "query had returned an error_code #{error_code} : #{datas.split("\n")[1]}"
    end
  end
  
  def open_socket()
    
    socket = nil
    
    begin
      #open socket depending on the type of connection
      case @mk_livestatus_socket_type
        when "tcp"
          socket=TCPSocket.open(@mk_livestatus_socket_path[:ip], @mk_livestatus_socket_path[:port])
          puts "Ouverture du socket TCP : "+@mk_livestatus_socket_path[:ip]+" "+@mk_livestatus_socket_path[:port] if Nagios::MkLiveStatus::DEBUG
        when "file"
          socket=UNIXSocket.open(@mk_livestatus_socket_path)
          puts "Ouverture du socket Unix : "+@mk_livestatus_socket_path if Nagios::MkLiveStatus::DEBUG
      end
    rescue Exception => ex
      raise RequestException.new("Socket error : #{ex.message}")
    end
    
    if socket == nil
      raise RequestException.new("Socket error : socket type not recognized.")
    end
    
    return socket
  end
  
end