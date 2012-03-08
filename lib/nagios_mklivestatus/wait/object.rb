# This class is used to make a wait object.
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Wait::Object < Nagios::MkLiveStatus::Wait
  
  include Nagios::MkLiveStatus
  
  #
  # Create a new wait object expression.
  #
  def initialize(name)
    if not name
      raise QueryException.new("The object value must be set for the wait operation.")
    end
    
    @name = name
    
  end
  
  #
  # Convert the current object expression into a nagios query string.
  #  WaitObject: ...
  #
  def to_s
     return "WaitObject: "+@name
  end
end