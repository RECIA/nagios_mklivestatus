##
# General Exception for nagios. 
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Exception < Exception
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "query_exception")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "request_exception")
end