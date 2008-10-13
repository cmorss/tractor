require 'osx/cocoa'
require 'TicketView'

class ExpandedTicketRowView < CollapsedTicketRowView

  ib_outlet :description_field
  attr_reader :description_field

  def load_view
    super
    description_field.setString(@ticket.desc)
  end
  
  def preferred_height
    170
  end
end
