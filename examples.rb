require 'rubygems'
require 'nagios_mklivestatus'

query = Nagios::MkLiveStatus::Query.new()
query.get "hosts"
query.addColumn "host_name"
query.addColumn "groups"
query.addFilter "host_name = <name>"

mkliveTcp = Nagios::MkLiveStatus.new("tcp://<host>:<port>", {:debug =>true})
mkliveTcp.query(query)

mkliveTcp = Nagios::MkLiveStatus.new("tcp://<host>:<port>", {:debug =>true, :user => '<username>'})
mkliveTcp.query(query)

mkliveFile = Nagios::MkLiveStatus.new("<path>", {:debug =>true})
mkliveFile.query(query)