#
#  TicketWindow.rb
#  Tractor
#
#  Created by Charlie Morss on 10/20/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class TicketWindow <  OSX::NSWindow
  def initWithContentRect_styleMask_backing_defer(contentRect, aStyle, bufferingType, flag)

      # Call NSWindow's version of this function, but pass in the all-important value of NSBorderlessWindowMask
      # for the styleMask so that the window doesn't have a title bar
      result = super_initWithContentRect_styleMask_backing_defer(
        contentRect, OSX::NSBorderlessWindowMask, OSX::NSBackingStoreBuffered, false)
        
      # Set the background color to clear so that (along with the setOpaque call below) we can see through the parts
      # of the window that we're not drawing into
      result.setBackgroundColor(OSX::NSColor.clearColor)
      
      # This next line pulls the window up to the front on top of other system windows.  This is how the Clock app behaves;
      # generally you wouldn't do this for windows unless you really wanted them to float above everything.
      result.setLevel(OSX::NSStatusWindowLevel)
      
      # Let's start with no transparency for all drawing into the window
      result.setAlphaValue(1.0)
      # but let's turn off opaqueness so that we can see through the parts of the window that we're not drawing into
      result.setOpaque(false)

      # and while we're at it, make sure the window has a shadow, which will automatically be the shape of our custom content.
      result.setHasShadow(true)
      result
  end
  
  def canBecomeKeyWindow
    true
  end
end
