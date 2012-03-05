# This module is used to agregate all filter class into one module.
#
# It implements one method which will convert a standard filter to a string 
# output for Nagios.
#
# It also provides the following filter expressions:
# * Nagios::MkLiveStatus::Filter::Attr : standard attribute or field filter
# * Nagios::MkLiveStatus::Filter::List : list filter
# * Nagios::MkLiveStatus::Filter::And : "AND" operator between two filters expressions
# * Nagios::MkLiveStatus::Filter::Or : "OR" operator between two filters expressions
# * Nagios::MkLiveStatus::Filter::Negate : negate a filter expression
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Filter
  
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "attr_filter")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "list_filter")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "and")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "or")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "negate")
  
  # shortcut to Filter::Attr.new
  def self.Attr(name, comp, value)
    Attr.new(name, comp, value)
  end
  
  # shortcut to Filter::List.new
  def self.List(name, comp, value)
    List.new(name, comp, value)
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
  
protected
  # Convert the Filter class to the nagios query string.
  #
  # [name] name of the column or field to filter, if not set raise a QueryException.
  # [comp] comparator between the name and the value, if not set raise a QueryException.
  # [value] value to compare to the name
  #
  # Use the parameters to create a string corresponding to:
  #  Filter: name comp value
  #
  def to_s (name="", comp="", value="")
    if name == nil or name.empty?
      raise QueryException.new("The filter cannot be converted into string because the name of the attribute is not set.")
    end
    
    if comp == nil or comp.empty?
      raise QueryException.new("The filter cannot be converted into string because the comparator of the attribute is not set.")
    end
    
    if value == nil or value.empty?
      return "Filter: "+name+" "+comp 
    end
    
    return "Filter: "+name+" "+comp+" "+value;
  end
  
end