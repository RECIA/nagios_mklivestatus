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
  module MkLiveStatus

    require File.dirname(__FILE__)+'/nagios_mklivestatus/exception/query_exception'    
    require File.dirname(__FILE__)+'/nagios_mklivestatus/query'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/filter'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/request'
  
    # Initialize the nagios mklivestatus socket informations.
    #
    # Two type of socket are supported for now:
    # * TCP : path equal to "tcp://<host>:<port>"
    # * File : where path is the path to the file
    #
    # The second parameter is a hash of options of MkLiveStatus :
    # * :debug : will activate or not the debugging (true or false) 
    # * :user : is the user used with AuthUser of MkLiveStatus for hosts, services, hostgroups, servicegroup and log
    # 
    def prepare_request(path,options={:debug=> false})
      Request.new(path, options)
    end 

  end
end