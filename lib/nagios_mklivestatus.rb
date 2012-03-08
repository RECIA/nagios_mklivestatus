# This module holds the definition of the class used to query MkLiveStatus
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2011 GIP RECIA
# License::   General Public Licence
module Nagios
  # This module provides convenience methods to the application.
  # It also can be initiated or changed by the user to change parameters
  #
  # Author::    Esco-lan Team  (mailto:team@esco-lan.org)
  # Copyright:: Copyright (c) 2011 GIP RECIA
  # License::   General Public Licence
  module MkLiveStatus

    require File.dirname(__FILE__)+'/nagios_mklivestatus/exception'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/query_helper'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/filter'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/stats'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/wait'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/query'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/parser'
    require File.dirname(__FILE__)+'/nagios_mklivestatus/request'
    
    require 'logger'
    
    # Initialize the nagios mklivestatus informations.
    #
    # The parameter is a hash of options of MkLiveStatus :
    # * :log : options to activate or change the logger, if none provided keep the current conf or default if logger is not set. For logger options see set_logger 
    # 
    def self.init(options={})
        
      if options.has_key? :log
        self.set_logger(options[:log])
      elsif logger == nil
        self.set_logger()
      end
    end
    
    # logger helper while including
    # if called and logger not created it will initialize the default logger
    def logger
      if Nagios::MkLiveStatus.logger
        Nagios::MkLiveStatus.init
      end
      
      Nagios::MkLiveStatus.logger
    end

private   
    #
    # define the logger mode if it's not already defined
    # available options :
    # * :name : output name ; default : STDOUT. Can be File or string as Logger.new().
    # * :level : output severity ; default : Logger::ERROR.
    # * :shift_age : shift age, like in Logger.new(name, shift_age)
    # * :shift_size : shift size, like in Logger.new(name, shift_age, shift_size) only if shift_age is defined
    #
    def self.set_logger(options={})
      
      if options.has_key? :name and options[:name] != nil
        logger_name = options[:name]
      else
        logger_name = $stdout
      end
      
      if options.has_key? :level and options[:level] != nil
        logger_level = options[:level]
      else
        logger_level = Logger::ERROR
      end
      
      if options.has_key? :shift_age and options[:shift_age] != nil
        logger_shift_age = options[:shift_age]
        shift_age = true
      else
        shift_age = false
      end
      
      if options.has_key? :shift_size and options[:shift_size] != nil
        logger_shift_size = options[:shift_size]
        shift_size = true
      else
        shift_size = false
      end
      
      if logger_level == Logger::DEBUG
        if logger_name == $stdout
          log_name = "STDOUT"
        elsif logger_name == $stderr
          log_name = "STDERR"
        else
          log_name = logger_name.to_s
        end 
      end
      
      if shift_age and shift_size
        @logger = Logger.new(logger_name, logger_shift_age, logger_shift_size)
        init_logger(logger_level)
        @logger.debug("logger initialized with : #{[log_name, logger_shift_age, logger_shift_size].join(', ')}")
      elsif shift_age
        @logger = Logger.new(logger_name, logger_shift_age)
        init_logger(logger_level)
        @logger.debug("logger initialized with : #{[log_name, logger_shift_age].join(', ')}")
      else
        @logger = Logger.new(logger_name)
        init_logger(logger_level)
        @logger.debug("logger initialized with : #{log_name}")
      end
      
    end
    
    # Initialize the logger with the level and change the output format
    def self.init_logger(logger_level)
      @logger.level = logger_level
      @logger.formatter = proc do |severity, datetime, progname, msg|
        date_str = "#{datetime.strftime("%d/%m/%Y %H:%M:%S")}"
        prog_str = progname
        if prog_str == nil or prog_str.empty?
          prog_str = "Nag::MkLiv"
        elsif prog_str.length < 10
          (10 - prog_str.length).times do
            prog_str<< " "
          end
        else
          prog_str = prog_str[0,9]
        end
        
        spacer = ""
        if severity.length == 4
          spacer = " "
        end
        
        "#{date_str} [#{prog_str}] [#{severity}]#{spacer} : #{msg}\n"
      end
    end
    
    # provide the logger for the include
    def self.logger
      @logger
    end
    
  end
end