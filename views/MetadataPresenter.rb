
class MetadataPresenter
  
  def initialize(repository)
    @repository = repository
    load
  end
  
  def load
    @root_elements = [
      MetadataCollection.alloc.init_with_label_and_collection(
        :version, @repository.versions(true).to_a),

      MetadataCollection.alloc.init_with_label_and_collection(
        :owner, @repository.owners(true).to_a),

      MetadataCollection.alloc.init_with_label_and_collection(
        :reporter, @repository.reporters(true).to_a),
        
      MetadataCollection.alloc.init_with_label_and_collection(
        :milestone, @repository.milestones(true).select{|m| !m.completed? }.to_a),
        
      MetadataCollection.alloc.init_with_label_and_collection(
        :priority, @repository.priorities(true).to_a)
    ]
  end

  def update_stats(attribute, stats)
    collection = @root_elements.detect{|e| e.attribute == attribute}
     collection.children.each do |e|
      e.statistics = stats[e.element.name]
    end
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
    item.children.size
  end
  
  def child_of_item(index, item)
    item ? item.children[index] : @root_elements[index]
  end
  
  def dealloc
    @root_elements.each { |m| m.dealloc }    
  end
end

class MetadataCollection < OSX::NSObject
    
  def init_with_label_and_collection(label, collection)
    @label = label
    @collection = collection.map do |d| 
      MetadataElement.alloc.init_with_element(d, label)
    end
    self
  end
  
  def statistics
    nil
  end

  def attribute
    @label
  end
  
  def label
    @label.to_s.upcase
  end
  
  def expandable?
    true
  end
  alias_method :kind?, :expandable?
  
  def children
    @collection
  end
  
  def dealloc
    @collection.each { |e| e.dealloc }
  end
end

class MetadataElement < OSX::NSObject
  attr_accessor :element, :attribute_name, :statistics
    
  def init_with_element(element, attribute_name)
    @attribute_name = attribute_name
    @element = element
    self
  end
  
  def expandable?
    false
  end
  alias_method :kind?, :expandable?
  
  def label
    @element.name.to_s
  end
  
  def name
    @element.name
  end
end
