# This class is used to create a nagios mklivestatus query
# * get : is the object we are looking for
# * columns : are the fields we need from the object
# * filters : are the filters applied to the query
# * stats : are the stats applied to the query
# * wait : are the wait applied to the query
#
# By default the query get all the columns of the object without filter.
# If you add any objects (columns, filter, wait, ...) they will take place in the query
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2011 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Query
  
  include Nagios::MkLiveStatus
  
  @get=nil
  @columns=nil
  @filters=nil
  @before_wait=nil
  @after_wait=nil
  
  # Constructor of the Query instance
  # base is by default nil but if its filled the base if associated to the GET of the query
  def initialize(base=nil)
    get(base)
  end
  
  # Get method is used to set the object to search for in \nagios \mklivestatus
  def get(get)
    if get != nil and not get.empty?
      @get = get
    end
  end
  
  # Add a field to get in the query for the GET object
  def addColumn(name)
    if not name == nil or name.empty?
      if @columns == nil
        @columns=Array.new
      end
      
      @columns.push(name)
    end
  end
  
  # add wait to query but before filter predicats
  def addWaitBefore(expression)
    if expression.is_a? Nagios::MkLiveStatus::Wait
      if @before_wait == nil
        @before_wait = []
      end
      
      wait_adding expression, @before_wait
    end
  end
  
  # add wait to query but after filter predicats
  def addWaitAfter(expression)
    if expression.is_a? Nagios::MkLiveStatus::Wait
      if @after_wait == nil
        @after_wait = []
      end
      
      wait_adding expression, @after_wait
    end
  end
  
  # Add a filter to the query
  def addFilter(expression)
    if expression.is_a? Nagios::MkLiveStatus::Filter
      if @filters == nil
        @filters=Array.new
      end
      
      @filters.push(expression)
    else
      raise QueryException.new("The filter must be a filter expression.")
    end
  end
  
  # Add a stat filter 
  def addStats(expression)
    if expression.is_a? Nagios::MkLiveStatus::Stats
      if @stats == nil
        @stats=Array.new
      end
      
      @stats.push(expression)
    else
      raise QueryException.new("The filter must be a stat expression.")
    end
  end
  
  #short cut to the method to_socket
  def to_s
    return to_socket
  end
  
  # method used to generate the query from the field
  # if get is not set then the method return an empty string
  def to_socket
    query = String.new
    if @get != nil
      query << "GET "+@get+"\n"
      
      if @stats != nil and @stats.length > 0
        @stats.each do |stat|
          query << stat.to_s+"\n"
        end
      end
      
      if @columns != nil and @columns.length > 0
        query << "Columns:"
        @columns.each do |column|
          query << " "+column
        end
        query << "\n"
      end
      
      if @before_wait != nil and @before_wait.length > 0
        @before_wait.each do |wait|
          query << wait.to_s+"\n"
        end
      end
      
      if @filters != nil and @filters.length > 0
        @filters.each do |filter|
          query << filter.to_s+"\n"
        end
      end
      
      if @after_wait != nil and @after_wait.length > 0
        @after_wait.each do |wait|
          query << wait.to_s+"\n"
        end
      end
      
    end
    
    return query
  end
  
  #
  # check if the query have stats predicates
  #
  def has_stats
    @stats != nil and @stats.length > 0
  end
  
  #
  # get all the column name of the query
  #
  def get_columns_name
    columns = []
    if @columns != nil
      @columns.each do |column|
        columns.push column
      end
    end
      
    if @stats != nil and @stats.length > 0
      @stats.each do |stat|
        columns.push stat.to_column_name
      end
    end
      
    return columns
  end
  
protected
  # wait addind check if one of WaitObject, WaitTrigger, WaitTimeout are already set. 
  # And before/after filter exclusion
  def wait_adding(expr, list_expr)
    
    if expr.is_a? Nagios::MkLiveStatus::Wait::Object or expr.is_a? Nagios::MkLiveStatus::Wait::Trigger or expr.is_a? Nagios::MkLiveStatus::Wait::Timeout
      list_expr.each do |tmp|
        if tmp.kind_of? expr.class
          raise QueryException.new("Only one of each non-wait condition must be set.")
        end
      end
    end
    
    list_expr.push expr
    
    if not @before_wait and not @after_wait and @before_wait.length > 0 and @after_wait.length > 0 
      list_expr.pop
      raise QueryException.new("Wait expression can be set only before OR after filter.")
    end
  end
  
end