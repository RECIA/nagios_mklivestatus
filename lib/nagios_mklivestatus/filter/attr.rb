class Nagios::MkLiveStatus::Filter::Attr < Nagios::MkLiveStatus::Filter
  
  EQUAL = "="
  SUBSTR = "~"
  EQUAL_IGNCASE = "=~"
  SUBSTR_IGNCASE = "~~"
  LESSER = "<"
  GREATER = ">"
  LESSER_EQUAL = "<="
  GREATER_EQUAL = ">="
  
  NOT_EQUAL = "!="
  NOT_SUBSTR = "!~"
  NOT_EQUAL_IGNCASE = "!=~"
  NOT_SUBSTR_IGNCASE = "!~~"
  
  def initialize (attr_name, attr_comp, attr_value)
    
    list_comparator = [Attr::EQUAL, Attr::SUBSTR, Attr::EQUAL_IGNCASE , Attr::SUBSTR_IGNCASE, 
      Attr::LESSER, Attr::GREATER, Attr::LESSER_EQUAL, Attr::GREATER_EQUAL, 
      Attr::NOT_EQUAL, Attr::NOT_SUBSTR, Attr::NOT_EQUAL_IGNCASE, Attr::NOT_SUBSTR_IGNCASE]
    
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
    
    if attr_value == nil or attr_value.empty?
      raise QueryException.new("The value of the comparison must be set in order to create the filter")
    else
      @attr_value = attr_value
    end
    
  end
  
  def to_s
    return self.to_s(@attr_name, @attr_comp, @attr_value)
  end
  
end