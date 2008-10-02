class TicketStatus < ActiveRecord::Base
  belongs_to :repository
end

class TicketStatusProxy < ActiveRecordProxy
end
