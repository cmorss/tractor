#
#  TicketsCollectionView.rb
#  Tractor
#
#  Created by Charlie Morss on 9/30/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class TicketsCollectionView <  OSX::NSCollectionView

	ib_outlet :selectedTicketViewItem

  def initWithFrame(frame)
    super_initWithFrame(frame)
    # Initialization code here.
    setMaxItemSize(OSX::NSSize.new(10, 70))
    return self
  end
  
  def newItemForRepresentedObject(ticket)
    super_newItemForRepresentedObject(ticket)
    # if (ticket.id != 1)
    #   super_newItemForRepresentedObject(ticket)
    # else
    #   vi= TicketCollectionViewItem.alloc.init
    #   vi.view = SelectedTicketView.alloc.initWithFrame(frame)
    #   vi.setRepresentedObject(ticket)
    #   vi
    # end
  end
  
  def drawRect(rect)
    super_drawRect(rect)
    Color.colorFromHexRGB('A9ADB7').set
    OSX::NSBezierPath.fillRect(self.bounds)    
  end
end
