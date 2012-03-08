# This module is used to agregate all filter class into one module.
#
# It also provides the following filter expressions:
# * Nagios::MkLiveStatus::Filter::Attr : standard attribute or field filter
# * Nagios::MkLiveStatus::Filter::And : "AND" operator between two filters expressions
# * Nagios::MkLiveStatus::Filter::Or : "OR" operator between two filters expressions
# * Nagios::MkLiveStatus::Filter::Negate : negate a filter expression
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Filter
  
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "attr")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "and")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "or")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "negate")
  
end