# This class is used to agregate all waits class into one module.
#
# It also provides the following wait expressions:
# * Nagios::MkLiveStatus::Wait::Attr : standard attribute or field wait condition
# * Nagios::MkLiveStatus::Wait::And : "AND" operator between two wait conditions expressions
# * Nagios::MkLiveStatus::Wait::Or : "OR" operator between two wait conditions expressions
# * Nagios::MkLiveStatus::Wait::Negate : "NOT" operator for the last wait condition expressions
# * Nagios::MkLiveStatus::Wait::Object : symbolize the wait object
# * Nagios::MkLiveStatus::Wait::Trigger : wait trigger
# * Nagios::MkLiveStatus::Wait::Timeout : timeout of the wait
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Wait
  
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "attr")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "and")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "or")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "negate")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "trigger")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "object")
  require File.join(File.dirname(__FILE__), File.basename(__FILE__, ".rb"), "timeout")
  
protected
  #
  # Check if the expression is a valid wait condition (WaitCondition, WaitConditionAnd, WaitConditionOr)
  def check_valid_condition(expression)
    expression.is_a? Nagios::MkLiveStatus::Wait::And or expression.is_a? Nagios::MkLiveStatus::Wait::Or or expression.is_a? Nagios::MkLiveStatus::Wait::Attr
  end
  
end