class Severity < ActiveRecord::Base
  belongs_to :repository
end

class SeverityProxy < ActiveRecordProxy
end
