# This class symbolise a stats unit. This unit represents a small stat predicate like, in the nagios query, this : 
#  Stats: host_name = name
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Stats::Attr < Nagios::MkLiveStatus::Stats
  
  # equal or empty list : =
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
  
  # sum deviation
  SUM = "sum"
  
  # suminv deviation
  SUMINV = "suminv"
  
  # min deviation
  MIN = "min"
  
  # max deviation
  MAX = "max"
  
  # avg deviation
  AVG = "avg"
  
  # avginv deviation
  AVGINV = "avginv"
  
  # std deviation
  STD = "std"
  
  
  #
  # Create the unit predicate with the deviation, the column name, the operator use to compare, and the value :
  #  Stats: [dev] name [op value] 
  #
  # [attr_name] name of the column
  # [attr_comp] operator, one of the constant of the class
  # [attr_value] the value to compare to
  # [attr_mod] deviation of the predicate like avg, max, min
  #
  def initialize (attr_name, attr_comp, attr_value, attr_mod=nil)
    
    list_comparator = [Attr::EQUAL, Attr::SUBSTR, Attr::EQUAL_IGNCASE , Attr::SUBSTR_IGNCASE, 
      Attr::LESSER, Attr::GREATER, Attr::LESSER_EQUAL, Attr::GREATER_EQUAL, 
      Attr::NOT_EQUAL, Attr::NOT_SUBSTR, Attr::NOT_EQUAL_IGNCASE, Attr::NOT_SUBSTR_IGNCASE]
      
    list_deviation = [Attr::SUM, Attr::SUMINV, Attr::MIN , Attr::MAX, 
      Attr::LESSER, Attr::AVG, Attr::AVGINV, Attr::STD]
    
    if attr_name == nil or attr_name.empty?
      raise QueryException.new("The name of the attribute must be set in order to create the stats")
    else
      @attr_name = attr_name
    end
    
    if attr_mod != nil and list_deviation.index(attr_mod)
      raise QueryException.new("The deviantion of the attribute must be set to one of : #{list_deviation.join(", ")} in order to create the stats")
    else
      @attr_mod = attr_mod
    end
    
    if list_comparator.index(attr_comp) == nil and not @attr_mod
      raise QueryException.new("The comparator \"#{attr_comp}\" is not recognized.\n Please use one of : #{list_comparator.join(", ")}")
    else
      @attr_comp = attr_comp
    end
    
    @attr_value = attr_value
    
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
      raise QueryException.new("The stats cannot be converted into string because the name of the attribute is not set.")
    end
    
    if (@attr_comp == nil or @attr_comp.empty?) and @attr_mod == nil
      raise QueryException.new("The stats cannot be converted into string because the comparator of the attribute is not set.")
    end
    
    stats = "Stats: "
    
    if @attr_mod != nil
      stats+=@attr_mod+" "
    end
    
    if @attr_value == nil or @attr_value.empty?
      return stats+@attr_name+" "+@attr_comp 
    end
    
    return stats+@attr_name+" "+@attr_comp+" "+@attr_value;
  end
  
end