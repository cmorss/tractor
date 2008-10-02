require 'osx/foundation'

class Hash
  def to_NSDictionary
    nsKeys = NSArray.arrayWithObjects(keys)
    vals = nsKeys.map{ |k| self[k] }
    nsValues = NSArray.arrayWithObjects(values)
    NSDictionary.dictionaryWithObjects_forKeys(nsValues, nsKeys)
  end  
end
