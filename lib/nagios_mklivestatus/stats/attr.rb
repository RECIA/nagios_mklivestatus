# This class symbolise a stats unit. This unit represents a small stat predicate like, in the nagios query, this : 
#  Stats: host_name = name
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Stats::Attr < Nagios::MkLiveStatus::Stats
  
  include Nagios::MkLiveStatus
  include Nagios::MkLiveStatus::QueryHelper::Comparator
  include Nagios::MkLiveStatus::QueryHelper::Deviation
  
  
  #
  # Create the unit predicate with the deviation, the column name, the operator use to compare, and the value :
  #  Stats: [dev] name [op value] 
  #
  # [attr_name] name of the column
  # [attr_comp] operator, one of the constant of the class
  # [attr_value] the value to compare to
  # [attr_mod] deviation of the predicate like avg, max, min
  #
  def initialize (attr_name, attr_comp=nil, attr_value=nil, attr_mod=nil)
    
    list_comparator = get_all_comparators
      
    list_deviation = get_all_deviations
    
    if attr_name == nil or attr_name.empty?
      ex = QueryException.new("The name of the attribute must be set in order to create the stats")
      logger.error(ex.message)
      raise ex
    else
      @attr_name = attr_name
    end
    
    if attr_comp == nil and attr_value == nil and attr_mod != nil and not attr_mod.empty? 
    
      if list_deviation.index(attr_mod) == nil
        ex = QueryException.new("The deviation #{attr_mod} of the attribute must be set to one of : #{list_deviation.join(", ")} in order to create the stats")
        logger.error(ex.message)
        raise ex
      else
        @attr_mod = attr_mod
      end
      
    elsif attr_comp != nil and attr_value != nil and attr_mod == nil
    
      if list_comparator.index(attr_comp) == nil
        ex = QueryException.new("The comparator \"#{attr_comp}\" is not recognized.\n Please use one of : #{list_comparator.join(", ")}")
        logger.error(ex.message)
        raise ex
      else
        @attr_comp = attr_comp
      end
    
      @attr_value = attr_value
    else
      ex = QueryException.new("The stats can't have both deviation and comparator")
      logger.error(ex.message)
      raise ex
    end
    
  end
  
  #
  # Convert the Stats class to the nagios query string.
  #
  # [name] name of the column or field to filter, if not set raise a QueryException.
  # [comp] comparator between the name and the value, if not set raise a QueryException.
  # [value] value to compare to the name
  #
  # Use the parameters to create a string corresponding to:
  #  Stats: name comp value
  #
  def to_s
    if @attr_name == nil or @attr_name.empty?
      ex = QueryException.new("The stats cannot be converted into string because the name of the attribute is not set.")
      logger.error(ex.message)
      raise ex
    end
    
    if (@attr_comp == nil or @attr_comp.empty?) and @attr_mod == nil
      ex = QueryException.new("The stats cannot be converted into string because the comparator of the attribute and the deviation are not set.")
      logger.error(ex.message)
      raise ex
    end
    
    stats = "Stats: "
    
    if @attr_mod != nil
      stats+=@attr_mod+" "+@attr_name
      return stats
    end
    
    if @attr_value == nil or @attr_value.empty?
      return stats+@attr_name+" "+@attr_comp 
    end
    
    return stats+@attr_name+" "+@attr_comp+" "+@attr_value;
  end
  
  # transform predicate to column name
  # same as the to_s but without "Stats: " (ex: "state = 0")
  def to_column_name(has_parent=false)
    if @attr_name == nil or @attr_name.empty?
      ex = QueryException.new("The stats cannot be converted into string because the name of the attribute is not set.")
      logger.error(ex.message)
      raise ex
    end
    
    if (@attr_comp == nil or @attr_comp.empty?) and @attr_mod == nil
      ex = QueryException.new("The stats cannot be converted into string because the comparator of the attribute and the deviation are not set.")
      logger.error(ex.message)
      raise ex
    end
    
    if @attr_mod != nil
      return @attr_mod+" "+@attr_name
    end
    
    if @attr_value == nil or @attr_value.empty?
      return @attr_name+" "+@attr_comp 
    end
    
    return @attr_name+" "+@attr_comp+" "+@attr_value;
  end
  
end