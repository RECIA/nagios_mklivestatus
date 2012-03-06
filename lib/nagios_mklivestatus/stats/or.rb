# This class is used to make a logical "OR" operator between two stats expression
#
# If one of the stats expression is also an "OR", 
# it takes all the expressions of the operator as its own.
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Stats::Or < Nagios::MkLiveStatus::Stats
  
  include Nagios::MkLiveStatus
  
  #
  # Create a new "OR" operator between left and right expressions.
  #
  # Those expressions must be of type Nagios::MkLiveStatus::Stats
  #
  def initialize(left_expr, right_expr)
    if not left_expr.is_a? Nagios::MkLiveStatus::Stats or not right_expr.is_a? Nagios::MkLiveStatus::Stats
      raise QueryException.new("The left and the right operand for an OR expression must be of Class Nagios::MkLiveStatus::Stats")
    end
    
    @expressions = Array.new
    if left_expr.is_a? Nagios::MkLiveStatus::Filter::Or
      left_expr.get_expressions.each do |expr|
        @expressions.push expr
      end
    else
      @expressions.push left_expr
    end
    
    if right_expr.is_a? Nagios::MkLiveStatus::Filter::Or
      right_expr.get_expressions.each do |expr|
        @expressions.push expr
      end
    else
      @expressions.push right_expr
    end

  end
  
  #
  # Return all the expressions under the "OR". It's used by 
  # the new method in order to get all "OR" expressions into the same object.  
  #
  def get_expressions
    return @expressions
  end
  
  #
  # Convert the current "OR" expression into a nagios query string
  #  Stats: ...
  #  Stats: ...
  #  StatsOr: 2
  #
  def to_s
    or_arr = []
    @expressions.each do |expr|
      or_arr.push expr.to_s
    end
    or_arr.push "StatsOr: #{@expressions.length}"
    return or_arr.join("\n")
  end
end