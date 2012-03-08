# This class is used to make a wait timeout.
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Wait::Timeout < Nagios::MkLiveStatus::Wait
  
  include Nagios::MkLiveStatus
  
  #
  # Create a new wait timeout expression.
  # _Timeout in millisecond_
  #
  def initialize(timeout)
    if not timeout
      raise QueryException.new("The timeout must be set for the wait operation.")
    end
    
    @timeout = timeout
    
  end
  
  #
  # Convert the current timeout expression into a nagios query string.
  #  WaitTimeout: ...
  #
  def to_s
     return "WaitTimeout: "+@timeout
  end
end