
class Component < ActiveRecord::Base
  belongs_to :repository
end

class ComponentProxy < ActiveRecordProxy
end
