#
#  SelectedTicketView.rb
#  Tractor
#
#  Created by Charlie Morss on 9/30/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class SelectedTicketView <  OSX::NSView

	ib_outlets :id_field, :summary_field
	attr_accessor :ticket
	
  def initWithFrame(frame)
    super_initWithFrame(frame)
    # Initialization code here.
  
    return self
  end

  def ticket=(ticket)
    @ticket = ticket
  end
  
  def dealloc
    super_dealloc
    ticket = nil
  end
  
  def drawRect(rect)    
    super_drawRect(rect)
        
    OSX::NSColor.redColor.set
    OSX::NSBezierPath.fillRect(self.bounds)
  end
end
