class Priority < ActiveRecord::Base
  belongs_to :repository
end

class PriorityProxy < ActiveRecordProxy
end

