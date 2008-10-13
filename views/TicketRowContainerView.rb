#
#  RootTicketRowView.rb
#  Tractor
#
#  Created by Charlie Morss on 10/12/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class TicketRowContainerView <  OSX::NSView
  ib_outlets :controller, :collapsed_view
  attr_accessor :controller, :collapsed_view
  
  def initWithFrame(frame)
    super_initWithFrame(frame)
    # Initialization code here.
    return self
  end
  
  def expand(expanded_view)
    @collapsed_view.removeFromSuperview
    addSubview(expanded_view)
    active_view.controller = controller
    active_view.ticket = controller.ticket
    active_view.reload
  end
  
  def collapse
    log("before remove and add")
    log("collapse.active_view = #{active_view}")
    log("collapse.@collapsed_view = #{@collapsed_view}")
    
    active_view.removeFromSuperview
    addSubview(@collapsed_view)
    log("after remove and add")
    log("collapse.active_view = #{active_view}")
    log("collapse.@collapsed_view = #{@collapsed_view}")

    # These resizes/origin calls make no difference
    # active_view.setFrameOrigin(OSX::NSPoint.new(0,0))
    # active_view.setFrameSize(OSX::NSSize.new(300, active_view.preferred_height))

    active_view.controller = controller
    active_view.reload
    setNeedsDisplay(true)
    active_view.setNeedsDisplay(true)
  end
  
  def expanded?
    subviews.first != @collapsed_view
  end
  
  def active_view
    subviews.first
  end
  
  def ticket=(ticket)
    active_view.ticket = ticket
  end
  
  def selected=(select)
    if active_view.selected != select
      active_view.selected = select
      active_view.setNeedsDisplay(true)
    end
  end
  
  def reload
    active_view.reload
  end
  
  def preferred_height
    active_view.preferred_height
  end  
  
  def log(msg)
    $stderr.puts msg
  end
end
