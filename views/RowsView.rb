class RowsView < OSX::NSView
	ib_outlet :delegate
	  
  def init
    super_init  
    @layout_needed = true
  end
  
  def isFlipped
    true
  end
  
  def performLayout
    my_height = 0
    subviews.each do |row|
      my_height += row.frame.size.height;
    end
    
    my_frame = self.frame
    setFrameSize(OSX::NSMakeSize(my_frame.size.width, [my_height, superview.frame.size.height].max))  
    
    # self.needsDisplay = true if my_frame.size.height != my_height 

    y_position = 0;

    subviews.each do |row|
      old_row_frame = row.frame
      new_row_frame = OSX::NSRect.new
      new_row_frame.origin.y = y_position
      new_row_frame.origin.x = 0
      new_row_frame.size.width = my_frame.size.width
      new_row_frame.size.height = 30 # old_row_frame.size.height

      row.setFrame(new_row_frame)
      # row.needsDisplay = true

      # log("subview being layed out to: y:     #{new_row_frame.origin.y}        x: #{new_row_frame.origin.x}")
      # log("subview being layed out to: width: #{new_row_frame.size.width} height: #{new_row_frame.size.height}")
      
      y_position += new_row_frame.size.height
    end
    
    @layout_needed = false
  end

  def add_row_for_ticket(ticket)
    ticket_view = create_row_view(ticket)
    ticket_view.ticket = ticket
    addSubview(ticket_view)
    @layout_needed = true
  end
  
  def drawRect(rect)
    performLayout # if @layout_needed
    super_drawRect(rect)

    Color.colorFromHexRGB('A9ADB7').set
    OSX::NSBezierPath.fillRect(self.bounds)
  end
  
  private #################################################################

  def create_row_view(ticket)    
    controller = TicketController.alloc.init
    loaded = NSBundle.loadNibNamed_owner('TicketView', controller)
    controller.ticket = ticket
    controller.view
  end
    
  def log(msg)
    $stderr.puts msg
  end
end
