require 'osx/cocoa'
require 'CollapsedTicketRowView'

class ExpandedTicketRowView < CollapsedTicketRowView

  ib_outlet :description_field
  attr_reader :description_field

  def awakeFromNib
    $stderr.puts "ExpandedTicketRowView.awakeFromNib"
    scroll_view = description_field.superview.superview
    scroll_view.removeFromSuperview
    # description_field.removeFromSuperview
    addSubview(description_field)
    position_description_field
    
    notificationCenter = OSX::NSNotificationCenter.defaultCenter
    notificationCenter.addObserver_selector_name_object(
      self, :description_frame_changed, 
      'NSViewFrameDidChangeNotification', description_field)

    # scroll_view.removeFromSuperview
  end
  
  # def isFlipped
  #   true
  # end
  
  def load_view
    @loaded = true
    super
    description_field.setString(@ticket.desc)
    position_description_field
  end
  
  def description_frame_changed(notification)
    position_description_field
  end
  
  def position_description_field
    description_field.setFrameOrigin(
      OSX::NSPoint.new(summary_field.frame.origin.x, 10))

    @preferred_height = summary_field.frame.size.height + 
      description_field.frame.size.height + 30
      
    self.setFrameSize(OSX::NSSize.new(frame.size.width, @preferred_height))
    
    NSNotificationCenter.defaultCenter.postNotificationName_object(
      'expanded_view_resized', superview)
  end
  
  def preferred_height
    @preferred_height
  end  
end
