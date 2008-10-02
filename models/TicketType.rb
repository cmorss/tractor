class TicketType < ActiveRecord::Base
  belongs_to :repository
end

class TicketTypeProxy < ActiveRecordProxy
end
