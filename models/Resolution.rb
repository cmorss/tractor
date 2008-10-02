class Resolution < ActiveRecord::Base
  belongs_to :repository
end

class ResolutionProxy < ActiveRecordProxy
end
