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
  
  # Initialize the nagios mklivestatus socket informations.
  #
  # Two type of socket are supported for now:
  # * TCP : path equal to "tcp://<host>:<port>"
  # * File : where path is the path to the file
  #
  def initialize(path)
    
    Nagios::MkLiveStatus::init(options)
    
    #check socket type
    # if the path start with tcp:// => tcp socket
    if path.strip.start_with?("tcp://")
      tmp = path[6,path.length]
      table = tmp.partition(":")
      @mk_livestatus_socket_type = "tcp"
      @mk_livestatus_socket_path = Hash.new
      @mk_livestatus_socket_path[:ip] = table[0]
      @mk_livestatus_socket_path[:port] = table[2]
      
      logger.info("type: "+@mk_livestatus_socket_type)
      logger.info("ip : "+@mk_livestatus_socket_path[:ip])
      logger.info("port : "+@mk_livestatus_socket_path[:port])
    # default socket type is set to file
    elsif File.exists? path
      @mk_livestatus_socket_path = path
      @mk_livestatus_socket_type = "file"
      
      logger.info("type : "+@mk_livestatus_socket_type)
      logger.info("file : "+@mk_livestatus_socket_path)
    end
  end
  
  # The method opens the socket and send the query then return the response of nagios
  # 
  # The query parameter must be set and be a Nagios::MkLiveStatus::Query reprensting the MKLiveStatus Query :
  #  GET hosts
  # or
  #  GET hosts
  #  Columns: host_name
  #  Filter: host_name ~ test
  #  ....
  #
  # The options parameter is added to the query:
  # * :user : is the user used with AuthUser of MkLiveStatus for hosts, services, hostgroups, servicegroup and log
  # * :column_headers : set to true to have headers of the query as first line (ColumnHeaders: on) 
  # * :limit : limitation of the output (Limit: X)
  # * :output : output format like json/python, if none provided set to CSV (OutputFormat: out)
  def query(query=nil, options={})
    
    #set column headers
    column_header = false
    if options.has_key? :column_headers and options[:column_headers]
      column_headers = true
    end
    
    #set user
    user = nil
    if options.has_key? :user and options[:user] != nil and not options[:user].empty?
      user = options[:user]
    end
    
    #set limit
    limit = nil
    if options.has_key? :limit and options[:limit] != nil and not options[:limit].to_i
      limit = options[:limit].to_i
    end
    
    #set output
    output = nil
    if options.has_key? :output and options[:output] != nil and not options[:output].empty?
      if ['json','python'].include?(options[:output])
        output = options[:output]
      else
        ex = RequestException.new("output must be one of #{['json','python'].join(', ')}")
        logger.error(ex.message)
        raise ex
      end
    end
   
    #if socket is generated and query exists
    if query != nil and query.is_a? Nagios::MkLiveStatus::Query and query.to_s.upcase.start_with?("GET ")
      
      strQuery = "#{query}"
      #the endline must be empty
      if not strQuery.end_with?("\n")
        strQuery << "\n"
      end
      
      #set user if needed
      if user != nil and not user.empty? and strQuery.match /^GET\s+(hosts|hostgroups|services|servicegroup|log)\s*$/
        strQuery << "UserAuth: #{user}\n"
      end
      
      # set columns headers
      if column_headers
        strQuery << "ColumnHeaders: on\n"
      end
      
      # set the limit
      if limit
        strQuery << "Limit: #{limit}"
      end
      
      #set the output format
      if output
        strQuery << "OutputFormat: #{output}"
      end
      
      logger.info("")
      logger.info("---")
      strQuery.split("\n").each do |line|
        logger.info(line)
      end
      logger.info("---")
      
      #get error message if some are given
      strQuery << "ResponseHeader: fixed16\n"
      
      socket = open_socket()
      
      logger.debug("querying ...")
      # query the socket
      socket.puts strQuery
      
      logger.debug("closing socket.")
      # close the socket
      socket.shutdown(Socket::SHUT_WR)
      logger.debug("socket closed.")
      
      # check data reception
      recieving = socket.recv(16)
      check_receiving_error recieving
      
      logger.debug("Reading results.")
      # get all the line of the socket
      response = socket.gets(nil)
      
      logger.info("Results :")
      response.split("\n").each do |line|
        logger.info(line)
      end
      
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
      ex = RequestException.new("query had returned an error_code #{error_code} : #{datas.split("\n")[1]}")
      logger.error(ex.message)
      raise ex
    end
  end
  
  def open_socket()
    
    socket = nil
    
    begin
      #open socket depending on the type of connection
      case @mk_livestatus_socket_type
        when "tcp"
          logger.debug("Open TCP socket : "+@mk_livestatus_socket_path[:ip]+" "+@mk_livestatus_socket_path[:port])
          socket=TCPSocket.open(@mk_livestatus_socket_path[:ip], @mk_livestatus_socket_path[:port])
          logger.debug("TCP socket opened.")
        when "file"
          logger.debug("Open unix socket : "+@mk_livestatus_socket_path)
          socket=UNIXSocket.open(@mk_livestatus_socket_path)
          logger.debug("Unix socket opened")
      end
    rescue Exception => ex
      ex = RequestException.new("Socket error : #{ex.message}")
      logger.error(ex.message)
      raise ex
    end
    
    if socket == nil
      ex = RequestException.new("Socket error : socket type not recognized.")
      logger.error(ex.message)
      raise ex
    end
    
    return socket
  end
  
end