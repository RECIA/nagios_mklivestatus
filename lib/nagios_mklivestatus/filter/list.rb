class Nagios::MkLiveStatus::Filter::List < Nagios::MkLiveStatus::Filter
  
  CONTAINS = ">="
  IS_EMPTY = "="
    
  def initialize (attr_name, attr_comp, attr_value)
    
    list_comparator = [List::CONTAINS, List::IS_EMPTY]
    
    if attr_name == nil or attr_name.empty?
      raise QueryException.new("The name of the attribute must be set in order to create the filter")
    else
      @attr_name = attr_name
    end
    
    if list_comparator.index(attr_comp) == nil
      raise QueryException.new("The comparator \"#{attr_comp}\" is not recognized.\n Please use one of : #{list_comparator.join(", ")}")
    else
      @attr_comp = attr_comp
    end
    
    if (attr_value == nil or attr_value.empty?) and attr_comp != @@IS_EMPTY
      raise QueryException.new("The value of the comparison must be set in order to create the filter")
    else
      @attr_value = attr_value
    end
    
  end
  
  def to_s
    return self.to_s(@attr_name, @attr_comp, @attr_value)
  end
  
end