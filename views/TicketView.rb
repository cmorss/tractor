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
    self.idField.stringValue = @ticket.ticket_id
    # self.summaryField.bind_toObject_withKeyPath_options('value', @ticket, 'summary', nil)
  end

  def dealloc
    super_dealloc
    self.id_field.dealloc if self.id_field
    self.summary_field.dealloc if self.summary_field
    ticket = nil
  end
  
  def drawRect(rect)
    # $stderr.puts "drawing for ticket #{@ticket.ticket_id}"
    super_drawRect(rect)
    
    $stderr.puts "subviews: #{subviews.size}"
    OSX::NSColor.blueColor.set
    subviews.each do |v|
      OSX::NSRectFill(OSX::NSRect.new(v.frame.origin.x, 
            v.frame.origin.y, v.bounds.width, v.bounds.height))
      # v.drawRect(OSX::NSRect.new(v.frame.origin.x, 
      #       v.frame.origin.y, v.bounds.width, v.bounds.height))
    end
    
    # $stderr.puts "idfield width: #{idField.bounds.width}, x: #{idField.frame.origin.x}, value: #{idField.stringValue}"
    clipShape = OSX::NSBezierPath.bezierPath;
    box = OSX::NSRect.new(bounds.x + 10, bounds.y + 1, bounds.width - 30, bounds.height)

    return if box.x < 0 || box.y < 0 || box.height <= 0 || box.width <= 0 

    clipShape.appendBezierPathWithRoundedRect_xRadius_yRadius(box, 5, 5)
    TicketView.gradient[@selected ? 'selected' : 'background'].drawInBezierPath_angle(clipShape,90.0)

    # Draw the priority
    box = OSX::NSRect.new(bounds.x + box.width + 3, box.y+2, 6, box.height - 4)
    clipShape = OSX::NSBezierPath.bezierPath;
    clipShape.appendBezierPathWithRoundedRect_xRadius_yRadius(box, 5, 5)
    TicketView.colors[@ticket.priority || 'minor'].set
    clipShape.fill
    
    # Summary field there?
    clipShape = OSX::NSBezierPath.bezierPath;    
    v = summaryField
    box = OSX::NSRect.new(v.frame.origin.x, v.frame.origin.y, v.bounds.width, v.bounds.height)
    clipShape.appendBezierPathWithRoundedRect_xRadius_yRadius(box, 4, 4)
    clipShape.fill    
  end
end
