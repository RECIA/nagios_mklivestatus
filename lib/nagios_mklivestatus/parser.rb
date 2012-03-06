# This module can be used to parse a nagios string query 
# in order to convert it into a Nagios::MkLiveStatus::Query
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
module Nagios::MkLiveStatus::Parser
  
  include Nagios::MkLiveStatus
  #
  # Parser method, takes the string and return a Nagios::MkLiveStatus::Query
  # The second parameter is the options of the parser. Those are the same of 
  # Nagios::MkLiveStatus::init
  #
  def self.parse(query_str, options={:debug=>false})
    
    Nagios::MkLiveStatus::init(options)
    
    if not query_str.is_a? String or query_str.empty?
      raise QueryException.new("The query is not valid. You must provide a valid string.")
    end
    
    query = Nagios::MkLiveStatus::Query.new
    
    #split all the lines in order to create a table of string commands
    commands = query_str.split("\n")
    
    # the first line is the GET of the query
    get = commands.shift.strip.match(/^GET (.*)$/)
    if get == nil
      raise QueryException.new("The query has no GET. The first line must match /^GET (.*)$/.")
    else
      query.get get[1]
    end
    
    columns_parsed=false
    stats = []
    columns = []
    filters = []
    
    commands.each do |command|
      command.strip!
      puts "> processing command \"#{command}\"" if Nagios::MkLiveStatus::DEBUG
      
      if command.match(/^Columns: /)
        if not columns_parsed
          puts ">> columns found \"#{command.match(/^Columns: (.*)$/)[1]}\"" if Nagios::MkLiveStatus::DEBUG
          columns = command.match(/^Columns: (.*)$/)[1].split(" ")
          columns_parsed = true
        else
          raise QueryException.new("The definitions of columns are encountered twice.")
        end
      elsif command.match(/^Stats(And|Or)?: /)
        
        if columns_parsed
          raise QueryException.new("The stats predicates must be defined before Columns : #{command}")
        end
        
        stats_dispatching(command, stats)
        
      elsif command.match(/^(Filter: |And: |Or: |Negate:)/)
        
        if not columns_parsed
          raise QueryException.new("The filters predicates must be defined after Columns : #{command}")
        end
        
        filter_dispatching(command, filters)
        
      elsif not command.empty?
        raise QueryException.new("The current query is not valid due to : #{command}")
      end
      
    end
    
    columns.each do |column|
      query.addColumn column
    end
    
    filters.each do |filter|
      query.addFilter filter
    end
    
    stats.each do |stat|
      query.addStats stat
    end
    
    return query
  end
  
private
  def self.stats_dispatching(command, stats=[])
    if command.match(/^Stats: /)
      
      predicates = command.match(/^Stats: ((\S+)\s(\S+)|(\S+) (\S+)\s?(\S+)?)$/)
      
      if predicates and predicates[4] and predicates[5]
        name = predicates[4]
        comp = predicates[5]
        value = predicates[6]
        puts ">> stats predicate found \"#{name} #{comp} #{value}\"" if Nagios::MkLiveStatus::DEBUG
      
        stat = Stats.Attr(name, comp, value, nil)
        stats.push(stat)
      elsif predicates and predicates[2] and predicates[3]
        deviation = predicates[2]
        name = predicates[3]
        puts ">> stats predicate found \"#{deviation} #{name}\"" if Nagios::MkLiveStatus::DEBUG
      
        stat = Stats.Attr(name, nil, nil, deviation)
        stats.push(stat)
      else
        raise QueryException.new("The stats predicate can't be parsed : #{command}")
      end
      
    elsif command.match(/^StatsAnd: /)
      number = command.match(/^StatsAnd: (\d)$/)[1].to_i
      if number <= 1
        raise QueryException.new("The StatAnd predicate must be above 1.")
      end
      
      (number-1).times do |idx|
        right_stat = stats.pop
        left_stat = stats.pop
        andStats = Stats::And(left_stat, right_stat)
        stats.push(andStats)
      end
    elsif command.match(/^StatsOr: /)
      number = command.match(/^StatsOr: (\d)$/)[1].to_i
      if number <= 1
        raise QueryException.new("The StatOr predicate must be above 1.")
      end
      
      (number-1).times do |idx|
        right_stat = stats.pop
        left_stat = stats.pop
        orStats = Stats::Or(left_stat, right_stat)
        stats.push(orStats)
      end
    end
  end
  
  def self.filter_dispatching(command, filters=[])
    if command.match(/^Filter: /)
      predicates = command.match(/^Filter: (\S+) (\S+)\s?(\S+)?$/)
      
      name = predicates[1]
      comp = predicates[2]
      value = predicates[3]
      
      puts ">> filter predicate found \"#{name} #{comp} #{value}\"" if Nagios::MkLiveStatus::DEBUG
      
      filter = Filter::Attr(name, comp, value)
      filters.push(filter)
    elsif command.match(/^And: /)
      number = command.match(/^And: (\d)$/)[1].to_i
      if number <= 1
        raise QueryException.new("The And predicate must be above 1.")
      end
      
      (number-1).times do |idx|
        right_filter = filters.pop
        left_filter = filters.pop
        andFilter = Filter::And(left_filter, right_filter)
        filters.push(andFilter)
      end
    elsif command.match(/^Or: /)
      number = command.match(/^Or: (\d)$/)[1].to_i
      if number <= 1
        raise QueryException.new("The Or predicate must be above 1.")
      end
      
      (number-1).times do |idx|
        right_filter = filters.pop
        left_filter = filters.pop
        orFilter = Filter::Or(left_filter, right_filter)
        filters.push(orFilter)
      end
    elsif command.match(/^Negate:/)
      filter = filters.pop
      negateFilter = Filter::Negate(filter)
      filters.push(negateFilter)
    end
  end
end