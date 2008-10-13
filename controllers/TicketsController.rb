#
#  TicketsController.rb
#  Tractor
#
#  Created by Charlie Morss on 9/9/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class TicketsController < ActiveRecordSetController

  ib_outlet :view
	ib_action :refresh
	ib_action :select
	ib_action :do_foo
	
	kvc_accessor :tickets
  
  def init
    if super_init
      @tickets = []
      # This will load/create the dbfile in:
      # user/Library/Application Support/MailDemoActiveRecordBindingsApp/MailDemoActiveRecordBindingsApp.sqlite
      ActiveRecordConnector.connect_to_sqlite_in_application_support :log => true      
      return self
    end
  end
  
  def repository 
    AppController.instance.repository
  end
  	  
  def refresh(sender)
    # repository.sync_tickets
    @tickets = repository.tickets.find(:all, :limit => 10, :order => 'ticket_id')
    self.content = @tickets
        
    @tickets.each do |ticket|
      @view.add_or_update_row_for_ticket(ticket) 
    end
    
    @view.display
  end

  def do_foo(sender)
    @tickets.each {|t| t.ticket_id = 456}
    @view.display
  end
  
  private #################################################################
  
  def log(msg)
    $stderr.puts msg
  end
end
