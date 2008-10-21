#
#  MetadataController.rb
#  Tractor
#
#  Created by Charlie Morss on 9/18/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class MetadataController < OSX::NSWindowController
	ib_outlets :outlineView
	ib_action  :refresh

  attr_reader :outlineView
  
  def refresh
    @presenter.clear
    @outlineView.reloadData

    repository.sync_metadata
    repository.load_metadata
    
    log "respository.milestones = #{repository.milestones.to_a.inspect}"
    @presenter.load
    log "repository.owners = #{repository.owners.size}"
    @outlineView.reloadData
  end

  def repository
    AppController.instance.repository
  end

  def presenter
    @presenter ||= MetadataPresenter.new(repository)
  end
  
  def outlineView_numberOfChildrenOfItem(outlineView, item)
    count = item ? presenter.number_of_children_for_element(item) : presenter.number_of_root_elements
    # log "outlineView_numberOfChildrenOfItem: returning #{count}"
    count
  end

  def outlineView_child_ofItem(outlineView, index, item)
    # log("outlineView_child_ofItem called with index #{index.inspect} and item: #{item.inspect}")
    presenter.child_of_item(index, item)
  end

  def to_cfstring(str)
    CFStringCreateWithCString(KCFAllocatorDefault, str ? str.to_s : 'nil', KCFStringEncodingASCII)
  end
  
  def outlineView_isItemExpandable(outlineView, item)
    item.expandable?
  end

  def outlineView_objectValueForTableColumn_byItem(outlineView, tableColumn, item)
    if tableColumn.identifier == 'value'
      to_cfstring(item.label)
    else 
      to_cfstring(item.statistics || '')
    end
  end
  
  def outlineView_isGroupItem(outlineView, item)
    item.expandable?
  end
  
  def outlineViewSelectionDidChange(notification)
    outline_view = notification.object
    
    selected_items = []
    enumerator = outline_view.selectedRowEnumerator
    while (selected_row = enumerator.nextObject)
      selected_items << outline_view.itemAtRow(selected_row.integerValue)
    end
    
    where = []
    binds = {}
    
    selected_items.select{|i| !i.kind?}.each do |e|
      (binds[e.attribute_name] ||= []) << e.element.name
      if binds[e.attribute_name].size == 1
        where << "(#{e.attribute_name} in (:#{e.attribute_name}))"
      end
    end
    
    conditions = binds.empty? ? [] : [where.join(' and '), binds]
    
    update_stats(:milestone, conditions)
    update_stats(:priority,  conditions)
    update_stats(:version,  conditions)
    update_stats(:owner, conditions)
    update_stats(:reporter,  conditions)

    tickets_controller.conditions = conditions
    tickets_controller.refresh
    outline_view.reloadData
  end
  
  private #################################################################
  
  def update_stats(meta, conditions)
    results = if conditions.empty?
      []
    else
      Ticket.find(:all, 
        :select => "count(*) as cnt, #{meta}",
        :conditions => conditions, 
        :group => meta.to_s )
    end
    
    stats = {}
    results.each {|t| stats[t[meta]] = t.cnt}
    presenter.update_stats(meta, stats)  
  end

  def tickets_controller
    AppController.instance.tickets_controller
  end
    
  def log(msg)
    $stderr.puts msg
  end
end
