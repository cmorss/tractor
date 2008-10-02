#
#  Repository.rb
#  Tractor
#
#  Created by Charlie Morss on 9/14/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

class RepositoryProxy < ActiveRecordProxy
end

class Repository < ActiveRecord::Base

  attr_reader :metadata
  
  has_many :tickets
  has_many :milestones, :order => :name
  has_many :ticket_types
  has_many :ticket_statuses
  has_many :severities
  has_many :resolutions
  has_many :priorities
  has_many :components
  has_many :versions 
  
  def sync_metadata
    calls = %w(milestone type status severity resolution priority component version).map do |meta|
      ["ticket.#{meta}.getAll"]
    end

    results = multicall(*calls).to_a
  
    %w(milestones ticket_types ticket_statuses severities resolutions priorities components versions).each_with_index do |collection, index|  
      records = send(collection.to_sym)
      records.destroy_all
      results[index].each { |value| records.create!(:name => value) }
    end
    @metadata = nil
  end

  def load_metadata
    @metadata = {}
    %w(milestones ticket_types ticket_statuses severities resolutions priorities components versions).each do |collection|
      @metadata[collection.to_sym] = send(collection.to_sym, true).to_a
    end
    @metadata
  end
  
  def sync_tickets
    results = call('ticket.getRecentChanges', XMLRPC::DateTime.new(2008,9,17,13,46,0))
    
    log "results = #{results.inspect}"
    
    ticket_ids = call('ticket.query')

    calls = ticket_ids.map do |ticket_id|
      ['ticket.get', ticket_id]
    end
  
    results = multicall(*calls)
    
    tickets.destroy_all

    results.each do |result|
      attrs = result[3]
      attrs.merge!(:desc => result[3].delete('description'),
                   :ticket_id => result[0],
                   :created_date => result[1],
                   :updated_date => result[2])
      tickets.create!(attrs)
    end
    
    tickets(true) # Force a reload
  end
  
  def call(method, *args)
    log "XMLRPC: #{method}: #{args.inspect}"
    xmlrpc_client.call("#{method.to_s}", *args)
  end
  
  def multicall(*calls)
    $stderr.puts "XMLRPC multicall: #{calls.inspect}"
    results = xmlrpc_client.multicall(*calls)
    log "XMLRPC multicall: returned: #{results.inspect}"
    results
  end
  
  def xmlrpc_client
    # 'http://cmorss:cmorss@trac.local/vendo/login/xmlrpc'
    @client ||= XMLRPC::Client.new2(full_url)
  end
  
  def full_url
    "http://#{username}:#{password}@#{host}/#{name}/login/xmlrpc"
  end
  
  def log(msg)
    $stderr.puts msg
  end
  
end
