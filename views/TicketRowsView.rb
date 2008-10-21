class TicketRowsView < OSX::NSView
	ib_outlet :delegate
  ib_outlet   :expanded_ticket_row_view
  attr_reader :expanded_ticket_row_view
  attr_accessor :layout_needed
  
  def init
    super_init
    @layout_needed = true
  end
  
  def awakeFromNib
    notificationCenter = OSX::NSNotificationCenter.defaultCenter
    
    notificationCenter.addObserver_selector_name_object(
      self, :expanded_view_resized, 
      'expanded_view_resized', nil)
  end

  def isFlipped
    true
  end

  def performLayout
    my_frame = self.frame
    my_height = 0
    subviews.each do |row|
      my_height +=  row.preferred_height
    end

    # log "performLayout: setting frame size in performLayout to width: #{my_frame.size.width}, height: #{[my_height, superview.frame.size.height].max}"
    setFrameSize(OSX::NSMakeSize(my_frame.size.width, [my_height, superview.frame.size.height].max))
    y_position = 0;

    subviews.each do |row|
      old_row_frame = row.frame
      new_row_frame = OSX::NSRect.new
      new_row_frame.origin.y = y_position
      new_row_frame.origin.x = 0
      new_row_frame.size.width = my_frame.size.width
      new_row_frame.size.height = row.preferred_height

      row.setFrame(new_row_frame)
      row.perform_layout

      # log("subview being layed out to: y:     #{new_row_frame.origin.y}        x: #{new_row_frame.origin.x}")
      # log("subview being layed out to: width: #{new_row_frame.size.width} height: #{new_row_frame.size.height}")
      y_position += new_row_frame.size.height
    end

    # self.needsDisplay = true if my_frame.size.height != my_height

    @layout_needed = false
  end

  def add_or_update_row_for_ticket(ticket)
    holder = holders[ticket.id]
    if holder
      holder.controller.ticket = ticket
    else
      ticket_view = create_row_view(ticket)
      addSubview(ticket_view)
    end
    @layout_needed = true
  end

  def expanded_view_resized(notification)
    @layout_needed = true
    setNeedsDisplay(true)
  end
  
  def drawRect(rect)
    # log("drawRect: rect.origin.y: #{rect.origin.y}")
    performLayout if @layout_needed
    super_drawRect(rect)

    Color.colorFromHexRGB('A9ADB7').set
    OSX::NSBezierPath.fillRect(self.bounds)
  end

  def expand(ticket)
    log("expanded in a method that I didn't think was called.")
    @expanded_holder.controller.collapse if @expanded_holder && !@expanded_holder.controller.expanded?
    @expanded_holder = holders[ticket.id]
    @expanded_holder.controller.expand(expanded_ticket_row_view)
    setNeedsDisplay(true)
  end
  
  def clear
    @holders = {}
    @expanded_holder = nil
    subviews.to_a.each {|v|v.removeFromSuperview}
  end
  
  def left_click_on_row(ticket_controller, event)
    # log("event.modifierFlags = #{event.modifierFlags.inspect}, OSX::NSCommandKeyMask = #{OSX::NSCommandKeyMask}")
    # log("(event.modifierFlags & OSX::NSCommandKeyMask)  = #{(event.modifierFlags & OSX::NSCommandKeyMask)}")
    if (event.modifierFlags & OSX::NSCommandKeyMask) == 0
      if event.clickCount == 2
        clear_all_selections
        ticket_controller.expand(expanded_ticket_row_view)
      elsif !ticket_controller.selected && !ticket_controller.expanded?
        if expanded_controller = find_expanded_controller
          expanded_controller.collapse 
        end
        clear_all_selections
        ticket_controller.selected = true
      end
      setNeedsDisplay(true)
    end
  end
  
  def clear_all_selections
    holders.values.each { |h| h.controller.selected = false }
  end
  
  def find_expanded_controller
    @holders.values.map{|h| h.controller}.detect{|c| c.expanded?}
  end
  
  # - (void)itemClicked: (CollectionViewItem *)item
  #               event: (NSEvent *)event
  # {
  #    NSArray *oldSelection = [self selectedIndexes];
  # 
  #    if (([event modifierFlags] & NSCommandKeyMask) != 0) {
  #       [item setIsSelected:![item isSelected]];
  #    } else if (([event modifierFlags] & NSShiftKeyMask) != 0) {
  #       [self growSelectionToItem:item];
  #    } else {
  #       [self setAllItemsSelected:NO];
  #       [item setIsSelected:YES];
  #       if ([event clickCount] == 2) {
  #          [[self target]
  #             performDoubleClickActionForIndex:[items indexOfObject:item]];
  #       }
  #    }
  #    [self scrollToItem:item];
  # 
  #    [self testSelectionChanged:oldSelection];
  # }

  
  private #################################################################

  def create_row_view(ticket)
    holder = TicketControllerHolder.alloc.init
    loaded = NSBundle.loadNibNamed_owner('TicketView', holder)
    holders[ticket.id] = holder
    holder.controller.ticket = ticket
    holder.controller.ticket_rows_view = self
    holder.controller.view
  end

  def holders
    @holders ||= {}
  end  

  def log(msg)
    $stderr.puts msg
  end
end
