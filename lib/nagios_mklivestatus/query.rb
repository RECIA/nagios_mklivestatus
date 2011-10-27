# This class is used to create a nagios mklivestatus query
# * get : is the object we are looking for
# * columns : are the fields we need from the object
# * filters : are the filters applied to the query
#
# By default the query get all the columns of the object without filter.
# If you add any columns or filter they will take place in the query
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2011 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Query
  
  @get=nil
  @columns=nil
  @filters=nil
  
  # Constructor of the Query instance
  # base is by default nil but if its filled the base if associated to the GET of the query
  def initialize(base=nil)
    get(base)
  end
  
  # Get method is used to set the object to search for in nagios mklivestatus
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
  
  # Add a filter to the query
  def addFilter(expression)
    if not expression == nil or expression.empty?
      if @filters == nil
        @filters=Array.new
      end
      
      @filters.push(expression)
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
      
      if @columns != nil and @columns.length > 0
        query << "Columns:"
        @columns.each do |column|
          query << " "+column
        end
        query << "\n"
      end
      
      if @filters != nil and @filters.length > 0
        @filters.each do |filter|
          query << "Filter: "+filter+"\n"
        end
      end
    end
    
    return query
  end
end