# This class is used to agregate all stats class into one module.
#
# It implements one method which will convert a standard stats to a string 
# output for Nagios.
#
# It also provides the following stats expressions:
# * Nagios::MkLiveStatus::Stats::Attr : standard attribute or field stats
# * Nagios::MkLiveStatus::Stats::And : "AND" operator between two stats expressions
# * Nagios::MkLiveStatus::Stats::Or : "OR" operator between two stats expressions
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Stats
  
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "attr")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "and")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "or")
  
end