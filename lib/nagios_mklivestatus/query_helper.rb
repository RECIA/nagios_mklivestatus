# This module is a Query helper. It provides convenient methods in order to create query, filter, stats.
# As sub modules, it contains all the constants for comparator and deviation operators.
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
module Nagios::MkLiveStatus::QueryHelper
  
  # create a nagios query
  def nagmk_query()
    Nagios::MkLiveStatus::Query.new
  end
  
  # create a filter with the parameters
  def nagmk_filter(name, comparator, value)
    Nagios::MkLiveStatus::Filter::Attr.new(name, comparator, value)
  end
  
  # split the string into 3 parameters in order to create the correct filter
  # must match the regular expression : /^(Filter: )?(\S+) (\S+) ?(\S+)?$/
  def nagmk_filter_from_str(filter_str)
    predicates = filter_str.strip.match(/^(Filter: )?(\S+) (\S+) ?(\S+)?$/)
    if predicates
      return nagmk_filter(predicates[2], predicates[3], predicates[4])
    end
    
    ex = QueryException.new("Can't create filter because the expression doesn't match /^(Filter: )?(\S+) (\S+) ?(\S+)?$/")
    logger.error(ex.message)
    raise ex
  end
  
  #create a stats with parameters
  def nagmk_stats(name, comparator, value, deviation=nil)
    Nagios::MkLiveStatus::Stats::Attr.new(name, comparator, value, deviation)
  end
  
  # split the string into 4 parameters in order to create the correct stats
  # must match the regular expression : /^(Stats: )?(\S+) (\S+) ?(\S+)?$/
  def nagmk_stats_from_str(stats_str)
    predicates = stats_str.strip.match(/^(Stats: )?(\S+) (\S+) ?(\S+)?$/)
    if predicates
      if Deviation::get_all_deviations.include? predicates[2]
        return nagmk_stats(predicates[3], nil, nil, predicates[2])
      else
        return nagmk_stats(predicates[2], predicates[3], predicates[4])
      end
    end
    
    ex = QueryException.new("Can't create filter because the expression doesn't match /^(Stats: )?(\S+) (\S+) ?(\S+)?$/")
    logger.error(ex.message)
    raise ex
  end
  
  # create the and filter expression between two filter
  def nagmk_and(filter1, filter2)
    Nagios::MkLiveStatus::Filter::And.new(filter1, filter2)
  end
  
  # create the or filter expression between two filter
  def nagmk_or(filter1, filter2)
    Nagios::MkLiveStatus::Filter::Or.new(filter1, filter2)
  end
  
  # create the negate filter expression
  def nagmk_negate(filter)
    Nagios::MkLiveStatus::Filter::Negate.new(filter)
  end
  
  # create the and stats expression between two stats
  def nagmk_stats_and(stats1, stats2)
    Nagios::MkLiveStatus::Stats::And.new(stats1, stats2)
  end
  
  # create the or stats expression between two stats
  def nagmk_stats_or(stats1, stats2)
    Nagios::MkLiveStatus::Stats::Or.new(stats1, stats2)
  end
  
  # This module contains all the comparators which can be used by stats and filter.
  # It provides a method that helps you to get a list of all operators
  #
  # Author::    Esco-lan Team  (mailto:team@esco-lan.org)
  # Copyright:: Copyright (c) 2012 GIP RECIA
  # License::   General Public Licence
  module Comparator
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
    
    #get all the comparator constants values 
    def get_all_comparators
      all=[]
      Comparator.constants(false).each do |const|
        all.push Comparator.const_get(const)
      end
      
      return all
    end
  end
  
  # This module contains all the deviations which can be used by stats.
  # It provides a method that helps you to get a list of all operators.
  #
  # Author::    Esco-lan Team  (mailto:team@esco-lan.org)
  # Copyright:: Copyright (c) 2012 GIP RECIA
  # License::   General Public Licence
  module Deviation
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
    
    #get all the deviation constants values 
    def get_all_deviations
      all=[]
      Deviation.constants(false).each do |const|
        all.push Deviation.const_get(const)
      end
      
      return all
    end
  end
  
  include Nagios::MkLiveStatus::QueryHelper::Comparator
  include Nagios::MkLiveStatus::QueryHelper::Deviation
  
end