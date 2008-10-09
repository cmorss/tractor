#
#  TicketView.rb
#  Tractor
#
#  Created by Charlie Morss on 9/26/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class TicketView <  TRTicketView
  
  attr_writer  :selected
	kvc_accessor :ticket

  class << self

    def gradient
      return @gradient if @gradient
      @gradient = {}
      @gradient['background'] = create_gradient('F0F0F0', 'FFFFFF')
      @gradient['selected'] = create_gradient('D2D7E8', 'E4EAFB')

      @gradient  
    end

    def colors
      return @colors if @colors    
      @colors = {}  
      @colors['blocker'] = Color.colorFromHexRGB('B82C2D')
      @colors['critical'] = Color.colorFromHexRGB('E08037')
      @colors['major'] = Color.colorFromHexRGB('FFE676')
      @colors['minor'] = Color.colorFromHexRGB('EED56C')      
      @colors['trivial'] = Color.colorFromHexRGB('FFFFFF')    
      @colors
    end
    
    def create_gradient(start, finish)
      start_color = Color.colorFromHexRGB(start)
      finish_color = Color.colorFromHexRGB(finish)
      NSGradient.alloc.initWithStartingColor_endingColor(start_color, finish_color)      
    end
  end
  
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
    self.id_field.dealloc if self.id_field
    self.summary_field.dealloc if self.summary_field
    ticket = nil
  end
  
  def drawRect(rect)
    super_drawRect(rect)
        
    clipShape = OSX::NSBezierPath.bezierPath;
    box = OSX::NSRect.new(bounds.x + 10, bounds.y + 1, bounds.width - 30, bounds.height)

    return if box.x < 0 || box.y < 0 || box.height <= 0 || box.width <= 0 
    
    clipShape.appendBezierPathWithRoundedRect_xRadius_yRadius(box, 5, 5)
    TicketView.gradient[@selected ? 'selected' : 'background'].drawInBezierPath_angle(clipShape,90.0)
 
    # Draw the priority
    box = OSX::NSRect.new(bounds.x + box.width + 3, box.y + 2, 6, box.height - 4)
    clipShape = OSX::NSBezierPath.bezierPath;
    clipShape.appendBezierPathWithRoundedRect_xRadius_yRadius(box, 5, 5)
    TicketView.colors[@ticket.priority || 'minor'].set
    clipShape.fill    
  end
end
