#
#  TicketsController.rb
#  Tractor
#
#  Created by Charlie Morss on 9/9/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class TicketsController < OSX::NSWindowController
	ib_outlet :ticketsView
	ib_action :refresh
	ib_action :select
	
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
    @tickets = repository.tickets.find(:all, :limit => 10).to_activerecord_proxies
    log "Tickets.size = #{@tickets.size}"
    @ticketsView.content = @tickets
  end
  
  def refreshcomplete(tickets)
    log "refresh complete called..."
    @tickets = tickets.dup
    @tableView.reloadData
  end
  
  private #################################################################
  
  def log(msg)
    $stderr.puts msg
  end
end
