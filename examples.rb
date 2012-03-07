################################################
## Examples of Nagios_mklivestatus simple use ##
################################################

require 'rubygems'
require 'nagios_mklivestatus'

## changing nagios logging
# options
nagios_opt = {
  :log => { #logger options used to override default options
    :name => STDOUT, # name of the logger like in Logger.new(name)
    :shift_age => nil, # shift age of the logger like in Logger.new(name, shift_age) used if defined or not nil
    :shift_size => nil, # shift size of the logger like in Logger.new(name, shift_age, shift_size) used if defined or not nil and if shift_age is defined
    :level => Logger::ERROR # logger level  logger.level = Logger::ERROR
  }
}
# setting change
Nagios::MkLiveStatus.init(nagios_opt)

#creating a query with the API
query = Nagios::MkLiveStatus::Query.new()
query.get "hosts"
query.addColumn "host_name"
query.addColumn "groups"
query.addFilter "host_name = <name>"

# creating a query with the parser
query_str = ""
query_str << "GET hosts\n"
query_str << "Columns: host_name groups\n"
query_str << "Filter: host_name = <name>"
include Nagios::MkLiveStatus::Parser
query = nagmk_parse(query_str) #options can be defined

# creating a tcp client with log option
mkliveTcp = Nagios::MkLiveStatus::Request.new("tcp://<host>:<port>")
#query without options
mkliveTcp.query(query)
#query with user authentication and column headers
mkliveTcp.query(query, {:user => '<username>', :column_headers => true})

# creating a file socket client with debug option
mkliveFile = Nagios::MkLiveStatus::Request.new("<path>")
mkliveFile.query(query)