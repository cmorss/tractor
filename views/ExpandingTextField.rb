#
#  ExpandingTextField.rb
#  Tractor
#
#  Created by Charlie Morss on 10/16/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class ExpandingTextField <  NSTextView

  def awakeFromNib
    $stderr.puts "ExpandingTextField.awakeFromNib"
    self.setVerticallyResizable(true)
		self.textContainer().setHeightTracksTextView(false)
		self.textContainer().setContainerSize(OSX::NSSize.new(500,1000000))
  end
  
  # def initWithView(view)
  #   super_initWithView(view)
  #   return self
  # end
  # 
  # def autosize  
  #   fieldEditor = window.fieldEditor_forObject(true, self)
  # 
  #   new_frame = self.frame
  #   old_height = new_frame.size.height
  # 
  #   new_height = fieldEditor.layoutManager.usedRectForTextContainer(
  #          fieldEditor.textContainer).size.height + 10
  # 
  #   field_growth = new_height - old_height;   
  #   $stderr.puts "new_height = #{new_height}"
  #   if field_growth != 0
  #     # We're expanding or contracting. First adjust our frame, 
  #     # then see about superviews.
  # 
  #     new_frame.size = OSX::NSMakeSize(new_frame.size.width, new_height)
  # 
  #     if self.autoresizingMask & NSViewMinYMargin
  #        new_frame.origin.y -= field_growth
  #     end
  #     
  #     self.setFrame(new_frame)
  #   end
  # end
end
