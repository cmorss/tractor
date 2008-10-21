require 'osx/cocoa'

class RoundedTextFieldCell <  OSX::NSTextFieldCell

  BADGE_BUFFER_LEFT = 4
  BADGE_BUFFER_TOP = 3
  BADGE_BUFFER_LEFT_SMALL = 2
  BADGE_CIRCLE_BUFFER_RIGHT = 5
  BADGE_TEXT_HEIGHT = 14
  BADGE_X_RADIUS = 7
  BADGE_Y_RADIUS = 8
  BADGE_TEXT_SMALL = 20

  def highlightColorInView(control_view)
      return OSX::NSColor.clearColor
  end
  
  def drawInteriorWithFrame_inView(a_rect, control_view)
      return unless self.intValue > 0
      
      # Set up badge string and size.
      badge = NSString.stringWithFormat("%d", self.intValue)
      badge_num_size = badge.sizeWithAttributes(nil)

      # Calculate the badge's coordinates.
      badge_width = badge_num_size.width + BADGE_BUFFER_LEFT * 2
      badge_width = BADGE_TEXT_SMALL if (badge_width < BADGE_TEXT_SMALL)

      badge_x = a_rect.origin.x + a_rect.size.width - BADGE_CIRCLE_BUFFER_RIGHT - badge_width
      badge_y = a_rect.origin.y + BADGE_BUFFER_TOP
      badge_num_x = badge_x + BADGE_BUFFER_LEFT
      
      badge_num_x += BADGE_BUFFER_LEFT_SMALL if (badge_width == BADGE_TEXT_SMALL)
      badgeRect = OSX::NSMakeRect(badge_x, badge_y, badge_width, BADGE_TEXT_HEIGHT)

      # Draw the badge and number.
      badgePath = NSBezierPath.bezierPathWithRoundedRect_xRadius_yRadius(badgeRect, 
        BADGE_X_RADIUS, BADGE_Y_RADIUS)
      
      dict = NSMutableDictionary.alloc.init
      dict.setValue_forKey(NSFont.boldSystemFontOfSize(10), NSFontAttributeName)
      dict.setValue_forKey(NSNumber.numberWithFloat(-0.25), NSKernAttributeName)
      
      if NSApp.mainWindow && NSApp.mainWindow.isVisible && !self.isHighlighted
          # The row is not selected and the window is in focus.
          OSX::NSColor.colorWithCalibratedRed_green_blue_alpha(0.53, 0.60, 0.74, 1.0).set
          badgePath.fill
          dict.setValue_forKey(OSX::NSColor.whiteColor, NSForegroundColorAttributeName)

      elsif NSApp.mainWindow && NSApp.mainWindow.isVisible
          # The row is selected and the window is in focus.
          OSX::NSColor.whiteColor.set
          badgePath.fill
          dict.setValue_forKey(OSX::NSColor.alternateSelectedControlColor, 
            NSForegroundColorAttributeName)
            
      elsif !NSApp.mainWindow #!NSApp.mainWindow.isVisible && !self.isHighlighted
          # The row is not selected and the window is not in focus.
          OSX::NSColor.disabledControlTextColor.set
          badgePath.fill
          dict.setValue_forKey(OSX::NSColor.whiteColor, NSForegroundColorAttributeName)

      else
          # The row is selected and the window is not in focus.
          OSX::NSColor.whiteColor.set
          badgePath.fill
          dict.setValue_forKey(OSX::NSColor.disabledControlTextColor, 
            NSForegroundColorAttributeName)
      end

      badge.drawAtPoint_withAttributes(OSX::NSMakePoint(badge_num_x + 1, badge_y + 1), dict)
  end
end
