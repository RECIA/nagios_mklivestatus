# This class is used to make a logical "AND" operator between two wait expressions.
#
# If one of the wait expression is also an "AND", 
# it takes all the expressions of the operator as its own.
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Wait::And < Nagios::MkLiveStatus::Wait
  
  include Nagios::MkLiveStatus
  
  #
  # Create a new "AND" operator between left and right expressions.
  #
  # Those expressions must be of type Nagios::MkLiveStatus::Wait
  #
  def initialize(left_expr, right_expr)
    if not check_valid_condition(left_expr) or not check_valid_condition(right_expr)
      raise QueryException.new("The left and the right operand for an OR expression must be valid wait conditions.")
    end
    
    @expressions = Array.new
    if left_expr.is_a? Nagios::MkLiveStatus::Wait::And
      left_expr.get_expressions.each do |expr|
        @expressions.push expr
      end
    else
      @expressions.push left_expr
    end
    
    if right_expr.is_a? Nagios::MkLiveStatus::Wait::And
      right_expr.get_expressions.each do |expr|
        @expressions.push expr
      end
    else
      @expressions.push right_expr
    end

  end
  
  #
  # Return all the expressions under the "AND". It's used by 
  # the new method in order to get all "AND" expressions into the same object.  
  #
  def get_expressions
    return @expressions
  end
  
  #
  # Convert the current "AND" expression into a nagios query string
  #  WaitCondition: ...
  #  WaitCondition: ...
  #  WaitConditionAnd: 2
  #
  def to_s
    and_arr = []
    @expressions.each do |expr|
      and_arr.push expr.to_s
    end
    and_arr.push "WaitConditionAnd: #{@expressions.length}"
    return and_arr.join("\n")
  end
  
end