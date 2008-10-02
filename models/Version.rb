class Version < ActiveRecord::Base
  belongs_to :repository
end

class VersionProxy < ActiveRecordProxy
end
