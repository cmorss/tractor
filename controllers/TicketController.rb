#
#  TIcketController.rb
#  Tractor
#
#  Created by Charlie Morss on 10/8/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class TicketController < OSX::NSObjectController

  ib_outlet :view
  kvc_accessor :ticket
  
  attr_reader :view
end
