#
#  rb_main.rb
#  Tractor
#
#  Created by Charlie Morss on 9/9/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#


require "rubygems"
require 'osx/cocoa'
require "osx/active_record"
include OSX


def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
    
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
    require( File.basename(path) )
  end 
end

if $0 == __FILE__ then
  rb_main_init  
  OSX.NSApplicationMain(0, nil)
end
