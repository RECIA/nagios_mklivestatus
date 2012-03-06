require 'rubygems'
require 'nagios_mklivestatus'

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
query = Nagios::MkLiveStatus::Parser.parse(query_str) #options can be defined

# creating a tcp client with debug option
mkliveTcp = Nagios::MkLiveStatus::Request.new("tcp://<host>:<port>", {:debug =>true})
mkliveTcp.query(query)

# creating a tcp client with debug option, authentication and column header in the results
mkliveTcp = Nagios::MkLiveStatus::Request.new("tcp://<host>:<port>", {:debug =>true, :user => '<username>', :column_headers => true})
mkliveTcp.query(query)

# creating a file socket client with debug option
mkliveFile = Nagios::MkLiveStatus::Request.new("<path>", {:debug =>true})
mkliveFile.query(query)