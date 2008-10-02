
class MetadataPresenter
  
  def initialize(repository)
    @root_elements = [
      MetadataCollection.alloc.init_with_label_and_collection('MILESTONES', repository.milestones.to_a),
      MetadataCollection.alloc.init_with_label_and_collection('PRIORITIES', repository.priorities.to_a)
    ]
  end
  
  def clear
    old = @root_elements.dup
    @root_elements = []
    old.each { |m| m.dealloc }
  end
  
  def number_of_root_elements
    @root_elements.size
  end
  
  def number_of_children_for_element(item)
    $stderr.puts("number_of_children_for_element: #{item.inspect}")
    item.children.size
  end
  
  def statistics_for_element(item)
  end
  
  def child_of_item(index, item)
    item ? item.children[index] : @root_elements[index]
  end
  
  def dealloc
    @root_elements.each { |m| m.dealloc }    
  end
end

class MetadataCollection < OSX::NSObject
  
  attr_accessor :label
  
  def init_with_label_and_collection(label, collection)
    @label = label
    @collection = collection.map do |d| 
      MetadataElement.alloc.init_with_element(d)
    end
    self
  end
  
  def statistics
    nil
  end
  
  def expandable?
    true
  end
  
  def children
    @collection
  end
  
  def dealloc
    @collection.each { |e| e.dealloc }
  end
end

class MetadataElement < OSX::NSObject
  attr_accessor :element
    
  def init_with_element(element)
    @element = element
    self
  end
  
  def statistics
    3
  end
  
  def expandable?
    false
  end
  
  def label
    @element.name
  end
end
