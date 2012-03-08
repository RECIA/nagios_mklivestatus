# This class is used to make a logical "NOT" operator for the expression.
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Wait::Negate < Nagios::MkLiveStatus::Wait
  
  include Nagios::MkLiveStatus
  
  #
  # Create a new "Not" operator to the expression.
  #
  # Those expressions must be of type Nagios::MkLiveStatus::Wait
  #
  def initialize(expr)
    if not check_valid_condition expr
      raise QueryException.new("The operand for a NEGATE expression must be one valid wait condition.")
    end
    
    @expression = expr
    
  end
  
  #
  # Return the expression under the "Negate". It's used by 
  # the to_s method in order to remove the overflow of Negate expression.  
  #
  def get_expression
    return @expression
  end
  
  #
  # Convert the current "Negate" expression into a nagios query string.
  #
  # If the sub expression is also a Negate, it returns the sub-sub expression without negating it.
  #  WaitCondition: ...
  #  WaitConditionNegate:
  #
  def to_s
    if @expression.is_a? Nagios::MkLiveStatus::Wait::Negate
      return @expression.get_expression.to_s
    else
      negate_arr = []
      negate_arr.push @expression.to_s
      negate_arr.push "WaitConditionNegate: "
      return negate_arr.join("\n")
    end
  end
end