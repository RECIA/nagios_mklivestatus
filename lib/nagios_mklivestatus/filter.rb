# This module is used to agregate all filter class into one module.
#
# It implements one method which will convert a standard filter to a string 
# output for Nagios.
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
  
  include Nagios::MkLiveStatus
  
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "attr")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "and")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "or")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "negate")
  
  # shortcut to Filter::Attr.new
  def self.Attr(name, comp, value)
    Attr.new(name, comp, value)
  end
  
  # shortcut to Filter::And.new
  def self.And(left_expr, right_expr)
    And.new(left_expr, right_expr)
  end
  
  # shortcut to Filter::Or.new
  def self.Or(left_expr, right_expr)
    Or.new(left_expr, right_expr)
  end
  
  # shortcut to Filter::Negate.new
  def self.Negate(expr)
    Negate.new(expr)
  end
  
end