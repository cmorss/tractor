class Milestone < ActiveRecord::Base
  belongs_to :repository
end

class MilestoneProxy < ActiveRecordProxy
end
