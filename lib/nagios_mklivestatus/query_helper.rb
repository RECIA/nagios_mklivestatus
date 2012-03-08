# This module is a Query helper. It provides convenient methods in order to create query, filter, stats, wait.
# As sub modules, it contains all the constants for comparator and deviation operators.
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
module Nagios::MkLiveStatus::QueryHelper
  
  #
  # Create a nagios query.
  # With get initiated if given in parameter.
  def nagmk_query(get=nil)
    if get
      query = Nagios::MkLiveStatus::Query.new(get)
    else
      query = Nagios::MkLiveStatus::Query.new
    end
    
    query
  end
  
  # Create a filter with the parameters.
  def nagmk_filter(name, comparator, value)
    Nagios::MkLiveStatus::Filter::Attr.new(name, comparator, value)
  end
  
  # Split the string into 3 parameters in order to create the correct filter.
  # Must match the regular expression : /^(Filter: )?(\S+) (\S+) ?(\S+)?$/
  def nagmk_filter_from_str(filter_str)
    predicates = filter_str.strip.match(/^(Filter: )?(\S+) (\S+) ?(\S+)?$/)
    if predicates
      return nagmk_filter(predicates[2], predicates[3], predicates[4])
    end
    
    raise QueryException.new("Can't create filter because the expression doesn't match /^(Filter: )?(\S+) (\S+) ?(\S+)?$/")
  end
  
  # Create a stats with parameters.
  def nagmk_stats(name, comparator, value, deviation=nil)
    Nagios::MkLiveStatus::Stats::Attr.new(name, comparator, value, deviation)
  end
  
  # Split the string into 4 parameters in order to create the correct stats.
  # Must match the regular expression : /^(Stats: )?(\S+) (\S+) ?(\S+)?$/
  def nagmk_stats_from_str(stats_str)
    predicates = stats_str.strip.match(/^(Stats: )?(\S+) (\S+) ?(\S+)?$/)
    if predicates
      if get_all_deviations.include? predicates[2]
        return nagmk_stats(predicates[3], nil, nil, predicates[2])
      else
        return nagmk_stats(predicates[2], predicates[3], predicates[4])
      end
    end
    
    raise QueryException.new("Can't create stats because the expression doesn't match /^(Stats: )?(\S+) (\S+) ?(\S+)?$/")
  end
  
  # Create a wait condition with the parameters.
  def nagmk_wait_condition(name, comparator, value)
    Nagios::MkLiveStatus::Wait::Attr.new(name, comparator, value)
  end
  
  # Split the string into 3 parameters in order to create the correct wait condition.
  # Must match the regular expression : /^(WaitCondition: )?(\S+) (\S+) ?(\S+)?$/
  def nagmk_wait_condition_from_str(wait_cond_str)
    predicates = wait_cond_str.strip.match(/^(WaitCondition: )?(\S+) (\S+) ?(\S+)?$/)
    if predicates
      return nagmk_wait_condition(predicates[2], predicates[3], predicates[4])
    end
    
    raise QueryException.new("Can't create wait condition because the expression doesn't match /^(WaitCondition: )?(\S+) (\S+) ?(\S+)?$/")
  end
  
  # Create the and filter expression between two filters.
  def nagmk_and(filter1, filter2)
    Nagios::MkLiveStatus::Filter::And.new(filter1, filter2)
  end
  
  # Create the or filter expression between two filters.
  def nagmk_or(filter1, filter2)
    Nagios::MkLiveStatus::Filter::Or.new(filter1, filter2)
  end
  
  # Create the negate filter expression.
  def nagmk_negate(filter)
    Nagios::MkLiveStatus::Filter::Negate.new(filter)
  end
  
  # Create the and stats expression between two stats.
  def nagmk_stats_and(stats1, stats2)
    Nagios::MkLiveStatus::Stats::And.new(stats1, stats2)
  end
  
  # Create the or stats expression between two stats.
  def nagmk_stats_or(stats1, stats2)
    Nagios::MkLiveStatus::Stats::Or.new(stats1, stats2)
  end
  
  # Create the and wait expression between two wait conditions.
  def nagmk_wait_condition_and(wait1, wait2)
    Nagios::MkLiveStatus::Wait::And.new(wait1, wait2)
  end
  
  # Create the or wait expression between two wait conditions.
  def nagmk_wait_condition_or(wait1, wait2)
    Nagios::MkLiveStatus::Wait::Or.new(wait1, wait2)
  end
  
  # Create the negate wait condition expression.
  def nagmk_wait_condition_negate(wait)
    Nagios::MkLiveStatus::Wait::Negate.new(wait)
  end
  
  # Create the wait trigger expression.
  def nagmk_wait_condition_trigger(trigger=nil)
    
    if trigger
      wait = Nagios::MkLiveStatus::Wait::Trigger.new(trigger)
    else
      wait = Nagios::MkLiveStatus::Wait::Trigger.new()
    end
    
    wait
  end
  
  # Create the wait object expression.
  def nagmk_wait_condition_object(obj_name)
    Nagios::MkLiveStatus::Wait::Object.new(obj_name)
  end
  
  # Create the wait timeout expression in milliseconds.
  def nagmk_wait_condition_timeout(timeout)
    Nagios::MkLiveStatus::Wait::Timeout.new(timeout)
  end
  
  # This module contains all the comparators which can be used by stats, wait and filter.
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
  
  # This module contains all the trigger which can be used by wait.
  # It provides a method that helps you to get a list of all triggers.
  #
  # Author::    Esco-lan Team  (mailto:team@esco-lan.org)
  # Copyright:: Copyright (c) 2012 GIP RECIA
  # License::   General Public Licence
  module Trigger
    
    # a service or host check has been executed
    CHECK = "check"
    
    # the state of a host or service has changed
    STATE = "state"
    
    # a new message has been logged into nagios.log
    LOG = "log"
    
    # a downtime has been set or removed
    DOWNTIME = "downtime"
    
    # a comment has been set or removed
    COMMENT = "comment"
    
    # an external command has been executed
    COMMAND = "command"
    
    # any of the upper events happen (this is the default)
    ALL = "all"

    
    #get all the trigger constants values 
    def get_all_triggers
      all=[]
      Trigger.constants(false).each do |const|
        all.push Trigger.const_get(const)
      end
      
      return all
    end
  end
  
  include Nagios::MkLiveStatus::QueryHelper::Comparator
  include Nagios::MkLiveStatus::QueryHelper::Deviation
  include Nagios::MkLiveStatus::QueryHelper::Trigger
  
end