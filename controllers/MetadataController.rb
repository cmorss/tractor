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

  def refresh
    @presenter.clear
    @outlineView.reloadData

    repository.sync_metadata
    repository.load_metadata
    
    log "respository.milestones = #{repository.milestones.to_a.inspect}"
    @presenter = nil
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
    log "outlineView_numberOfChildrenOfItem: returning #{count}"
    count
  end

  def outlineView_child_ofItem(outlineView, index, item)
    log("outlineView_child_ofItem called with index #{index.inspect} and item: #{item.inspect}")
    presenter.child_of_item(index, item)
  end

  def to_cfstring(str)
    CFStringCreateWithCString(KCFAllocatorDefault, str ? str.to_s : 'nil', KCFStringEncodingASCII)
  end
  
  def outlineView_isItemExpandable(outlineView, item)
    log("expandable? #{item.expandable?}")
    item.expandable?
  end

  def outlineView_objectValueForTableColumn_byItem(outlineView, tableColumn, item)
    if tableColumn.identifier == 'value'
      to_cfstring(item.label)
    else 
      to_cfstring(item.statistics || '')
    end
  end
  
  private #################################################################
  
  def log(msg)
    $stderr.puts msg
  end
end
