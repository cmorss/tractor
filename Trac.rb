#
#  Trac.rb
#  Tractor
#
#  Created by Charlie Morss on 9/9/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

require 'xmlrpc/client'

class Trac
  def initialize(url)
    # 'http://cmorss:cmorss@trac.local/vendo/login/xmlrpc'
    @client = XMLRPC::Client.new2(url)
  end

  def method_missing(m, *args)
    $stderr.puts "XMLRPC: #{m}: #{args.inspect}"
    cmd = args.shift
    @client.call("#{m.to_s}.#{cmd}", *args)
  end
  
  def multicall(*calls)
    $stderr.puts "XMLRPC multicall: #{calls.inspect}"
    results = @client.multicall(*calls)
    $stderr.puts "XMLRPC multicall: returned..."
    results
  end
end

