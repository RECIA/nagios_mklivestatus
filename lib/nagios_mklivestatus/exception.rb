##
# General Exception for nagios.
# Add logging error when raised
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Exception < Exception
  
  include Nagios::MkLiveStatus
  
  def initialize(msg=nil)
    super(msg)
    logger.error(msg)
  end
  
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "query_exception")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "request_exception")
end