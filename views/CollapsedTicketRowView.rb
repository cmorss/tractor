#
#  TicketView.rb
#  Tractor
#
#  Created by Charlie Morss on 9/26/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class CollapsedTicketRowView <  NSView
  ib_outlets :controller, :id_field, :summary_field, :owner_field
  attr_reader :controller, :id_field, :summary_field, :owner_field
  
  attr_accessor  :selected
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
      @colors['blocker']  = Color.colorFromHexRGB('B82C2D')
      @colors['critical'] = Color.colorFromHexRGB('E08037')
      @colors['major']    = Color.colorFromHexRGB('FFE676')
      @colors['minor']    = Color.colorFromHexRGB('EED56C')      
      @colors['trivial']  = Color.colorFromHexRGB('FFFFFF')    
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
    return self
  end

  def ticket=(ticket)
    @ticket = ticket
    load_view
  end

  def preferred_height
    26
  end
  
  def left_click_event?(event)
    (event.buttonNumber == 0) && (event.modifierFlags & OSX::NSControlKeyMask) == 0
  end
      
  def mouseUp(event)
    log("mouseUp called")
    if left_click_event?(event)
      controller.left_click_on_row(event)
    end    
  end
    
  def mouseDown(event)
    log("mouseDown called")
    # if left_click_event?(event)
    #   controller.left_click_on_row(event)
    # end    
  end
    
  def load_view
    id_field.stringValue = @ticket.ticket_id
    summary_field.stringValue = @ticket.summary
    owner_field.stringValue = @ticket.owner
  end
  alias_method :reload, :load_view
  
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
    
    log "redrawing for ticket: #{@ticket.ticket_id}"
    clipShape.appendBezierPathWithRoundedRect_xRadius_yRadius(box, 5, 5)
    TicketView.gradient[@selected ? 'selected' : 'background'].drawInBezierPath_angle(clipShape,90.0)
 
    # Draw the priority
    box = OSX::NSRect.new(bounds.x + box.width + 3, box.y + 2, 6, box.height - 4)
    clipShape = OSX::NSBezierPath.bezierPath;
    clipShape.appendBezierPathWithRoundedRect_xRadius_yRadius(box, 5, 5)
    TicketView.colors[@ticket.priority || 'minor'].set
    clipShape.fill    
  end
  
  def log(msg)
    $stderr.puts msg
  end
end
