#
#  TicketCollectionViewItem.rb
#  Tractor
#
#  Created by Charlie Morss on 10/1/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class TicketCollectionViewItem < OSX::NSCollectionViewItem
  def setRepresentedObject(ticket)
    super_setRepresentedObject(ticket)
    view.ticket = ticket
  end
  
  def setSelected(flag)
    $stderr.puts "selecting with flag: #{flag.inspect}"
    super_setSelected(flag)
    view.selected = (flag == 1)
    view.setNeedsDisplay(flag)
  end
end
