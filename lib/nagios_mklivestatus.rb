# This module holds the definition of the class used to query Nagios MkLiveStatus
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2011 GIP RECIA
# License::   General Public Licence
module Nagios
  # This class is used to create a request
  # It accepts the following socket:
  # * TCP : new("tcp://<host>:<port>")
  # * Unix : new("/var/lib/nagios/rw/live") 
  #
  # Author::    Esco-lan Team  (mailto:team@esco-lan.org)
  # Copyright:: Copyright (c) 2011 GIP RECIA
  # License::   General Public Licence
  module MkLiveStatus

    require File.dirname(__FILE__)+'/nagios_mklivestatus/exception/query_exception'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/exception/request_exception'    
    require File.dirname(__FILE__)+'/nagios_mklivestatus/query'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/filter'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/stats'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/request'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/parser'
    
    # Initialize the nagios mklivestatus socket informations.
    #
    # The parameter is a hash of options of MkLiveStatus :
    # * :debug : will activate or not the debugging (true or false) 
    # 
    def self.init(options={:debug=> false})
      self.set_debug_mode(options)
    end
    
    #
    # define the debug mode if it's not already defined
    #
    def self.set_debug_mode(options)

      #if not already defined
      if not Nagios::MkLiveStatus.const_defined?(:DEBUG, false)
        #set debug mode
        if options.has_key? :debug and options[:debug]
          Nagios::MkLiveStatus.const_set(:DEBUG, true)
        else
          Nagios::MkLiveStatus.const_set(:DEBUG, false)
        end
      end
      
    end
    
  end
end