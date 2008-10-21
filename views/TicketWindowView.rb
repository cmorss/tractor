#
#  TicketWindowView.rb
#  Tractor
#
#  Created by Charlie Morss on 10/20/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class TicketWindowView <  OSX::NSView

  def awakeFromNib
    setNeedsDisplay(true)
  end
  
  def drawRect(rect)
    # clipShape = OSX::NSBezierPath.bezierPath;
    # clipShape.appendBezierPathWithRoundedRect_xRadius_yRadius(rect, 15, 15)
    # CollapsedTicketRowView.gradient['background'].drawInBezierPath_angle(clipShape,90.0)
    
    clipShape = OSX::NSBezierPath.bezierPath;    
    clipShape.appendBezierPathWithRect(rect)    
    CollapsedTicketRowView.gradient['background'].drawInBezierPath_angle(clipShape,90.0)    
  end
end
