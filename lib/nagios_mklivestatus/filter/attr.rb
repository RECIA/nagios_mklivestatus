# This class symbolise a filter unit. This unit represents a small filter predicate like, in the nagios query, this : 
#  Filter: host_name = name
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Filter::Attr < Nagios::MkLiveStatus::Filter
  
  include Nagios::MkLiveStatus
  
  # equal filter or empty list : =
  EQUAL = "="
  
  # regular expression like /<expr>/ : ~
  SUBSTR = "~"
  
  # equal ignore case : =~
  EQUAL_IGNCASE = "=~"
  
  # regular expression ignoring case : ~~
  SUBSTR_IGNCASE = "~~"
  
  # less than in alphabetical order : <
  LESSER = "<"
  
  # greater than in alphabetical order : >
  GREATER = ">"
  
  # less or equal to in alphabetical order : <=  
  LESSER_EQUAL = "<="
  
  # less or equal to in alphabetical order or list contains : >=
  GREATER_EQUAL = ">="
  
  # not equals to : !=
  NOT_EQUAL = "!="
  
  # not matching substring : !~
  NOT_SUBSTR = "!~"
  
  # not equals to ignoring case : !=~
  NOT_EQUAL_IGNCASE = "!=~"
  
  # not matching substring ignoring case : !~~
  NOT_SUBSTR_IGNCASE = "!~~"
  
  #
  # Create the unit predicate with the column name, the operator use to compare, and the value
  # [attr_name] name of the column
  # [attr_comp] operator, one of the constant of the class
  # [attr_value] the value to compare to
  #
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
      raise QueryException.new("The stats cannot be converted into string because the name of the attribute is not set.")
    end
    
    if @attr_comp == nil or @attr_comp.empty?
      raise QueryException.new("The stats cannot be converted into string because the comparator of the attribute is not set.")
    end
    
    
    if @attr_value == nil or @attr_value.empty?
      return "Filter: "+@attr_name+" "+@attr_comp 
    end
    
    return "Filter: "+@attr_name+" "+@attr_comp+" "+@attr_value;
  end
  
end