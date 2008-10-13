#
#  TicketController.rb
#  Tractor
#
#  Created by Charlie Morss on 10/8/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class TicketController < OSX::NSViewController
  attr_writer :ticket_rows_view
  attr_accessor :selected
  kvc_accessor :ticket

  def ticket=(ticket)
    @ticket.remove_observers if @ticket
    @ticket = ticket
    view.ticket = ticket
    @ticket.add_observer(self)
  end

  def collapse
    view.collapse
  end
  
  def expand(expanded_view)
    view.expand(expanded_view)
  end
    
  def expanded?
    view.expanded?
  end

  def selected=(select)
    @selected = select
    view.selected = @selected
    view.setNeedsDisplay(true)
  end
  
  def reload_view
    view.reload
  end

  # Fired when the model changes
  def observed_changed(observed, attribute, new_value, old_value)
    reload_view
  end
  
  # Called from one of the managed views is left clicked (mouse up)
  def left_click_on_row(event)
    @ticket_rows_view.left_click_on_row(self, event)
  end

  def dealloc
    @ticket.remove_observers if @ticket
    view.dealloc
    super_dealloc
  end
end
