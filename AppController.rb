#
#  AppController.rb
#  Tractor
#
#  Created by Charlie Morss on 9/19/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class AppController < OSX::NSObject

  ib_outlet :metadata_controller
  ib_outlet :tickets_controller
  ib_outlet :ticket_view
  
  def self.instance
    OSX::NSApplication.sharedApplication.delegate
  end
  
  def applicationWillFinishLaunching(aNotification)
  end
    
  def repository
    return @repository if @repository
    
    log "loading repository.."
    @repository = Repository.find(:first) || 
        Repository.create!(:name => 'vendo', 
                         :host => 'trac.local',
                         :username => 'cmorss',
                         :password => 'cmorss');  
    
    @repository.load_metadata  
    @repository
  end
  
  def meta_controller
    @metadata_controller
  end
  
  def tickets_controller
    @tickets_controller
  end

  def ticket_view
    @ticket_view
  end
  
  private #################################################################
  
  def log(msg)
    $stderr.puts msg
  end  
end
