# This class symbolise a filter unit. This unit represents a small filter predicate like, in the nagios query, this : 
#  Filter: host_name = name
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Filter::Attr < Nagios::MkLiveStatus::Filter
  
  include Nagios::MkLiveStatus
  include Nagios::MkLiveStatus::QueryHelper::Comparator
  
  #
  # Create the unit predicate with the column name, the operator use to compare, and the value
  # [attr_name] name of the column
  # [attr_comp] operator, one of the constant of the class
  # [attr_value] the value to compare to
  #
  def initialize (attr_name, attr_comp, attr_value)
    
    list_comparator = get_all_comparators
    
    if attr_name == nil or attr_name.empty?
      ex = QueryException.new("The name of the attribute must be set in order to create the filter")
      logger.error(ex.message)
      raise ex
    else
      @attr_name = attr_name
    end
    
    if list_comparator.index(attr_comp) == nil
      ex = QueryException.new("The comparator \"#{attr_comp}\" is not recognized.\n Please use one of : #{list_comparator.join(", ")}")
      logger.error(ex.message)
      raise ex
    else
      @attr_comp = attr_comp
    end
    
    @attr_value = attr_value
  end
  
  #
  # Convert the Filter class to the nagios query string.
  #
  # [name] name of the column or field to filter, if not set raise a QueryException.
  # [comp] comparator between the name and the value, if not set raise a QueryException.
  # [value] value to compare to the name
  #
  # Use the parameters to create a string corresponding to:
  #  Filter: name comp value
  #
  def to_s
    if @attr_name == nil or @attr_name.empty?
      ex = QueryException.new("The stats cannot be converted into string because the name of the attribute is not set.")
      logger.error(ex.message)
      raise ex
    end
    
    if @attr_comp == nil or @attr_comp.empty?
      ex = QueryException.new("The stats cannot be converted into string because the comparator of the attribute is not set.")
      logger.error(ex.message)
      raise ex
    end
    
    if @attr_value == nil or @attr_value.empty?
      return "Filter: "+@attr_name+" "+@attr_comp 
    end
    
    return "Filter: "+@attr_name+" "+@attr_comp+" "+@attr_value;
  end
  
end