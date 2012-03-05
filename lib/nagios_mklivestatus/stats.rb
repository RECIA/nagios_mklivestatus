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
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "negate")
  
  # shortcut to Stats::Attr.new
  def self.Attr(name, comp, value)
    Attr.new(name, comp, value)
  end
  
  # shortcut to Stats::And.new
  def self.And(left_expr, right_expr)
    And.new(left_expr, right_expr)
  end
  
  # shortcut to Stats::Or.new
  def self.Or(left_expr, right_expr)
    Or.new(left_expr, right_expr)
  end
  
end