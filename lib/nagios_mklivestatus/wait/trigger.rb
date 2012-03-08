# This class is used to make a wait trigger.
#
# Author::    Esco-lan Team  (mailto:team@esco-lan.org)
# Copyright:: Copyright (c) 2012 GIP RECIA
# License::   General Public Licence
class Nagios::MkLiveStatus::Wait::Trigger < Nagios::MkLiveStatus::Wait
  
  include Nagios::MkLiveStatus
  include Nagios::MkLiveStatus::QueryHelper::Trigger
  
  #
  # Create a new wait trigger expression.
  #
  def initialize(trigger=ALL)
    list_triggers = get_all_triggers
    if not list_triggers.include? trigger
      raise QueryException.new("The trigger value must be one of #{list_triggers.join(', ')}")
    end
    
    @trigger = trigger
    
  end
  
  #
  # Convert the current trigger expression into a nagios query string.
  #  WaitTrigger: ...
  #
  def to_s
     return "WaitTrigger: "+@trigger
  end
end