#
#  TicketControllerHolder.rb
#  Tractor
#
#  Created by Charlie Morss on 10/9/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'osx/cocoa'

class TicketControllerHolder < OSX::NSObject
  ib_outlet :controller
  attr_reader :controller
end
