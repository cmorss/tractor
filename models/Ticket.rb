# :id
# :component,
#   :cc,
#   :totalhours,
#   :status,
#   :estimatedhours,
#   :billable,
#   :resolution,
#   :reporter,
#   :ticket_rank,
#   :type,
#   :priority,
#   :version,
#   :summary,
#   :description,
#   :owner,
#   :hours,
#   :milestone,
#   :keywords
require 'xmlrpc/client'

class Ticket < ActiveRecord::Base

  belongs_to :repository

  class << self

    def inheritance_column
      "foo"
    end
    
    def load_from_trac(id)
      results = trac.ticket(:get, id)
      Ticket.createWithAttributes(results.merge(:id => id).to_NSDictionary)
    end

    def load_multiple(ticket_ids)
      tickets = {}
      missing = []
      ticket_ids.each do |ticket_id|
        tickets[ticket_id] = Cache.get(ticket_id)
        missing << ticket_id unless tickets[ticket_id]
      end
    
      unless missing.empty?
        more = load_multiple_from_trac(missing)
        log "load_multiple_from_trac returned"

        more.each {|t| tickets[t.id] = t}
      else
        log "got all #{ticket_ids.size} tickets from the cache"
      end
    
      ticket_ids.map{ |t_id| tickets[t_id] }
    end
  
    def load_multiple_from_trac(ticket_ids)
      calls = ticket_ids.map do |ticket_id|
        ['ticket.get', ticket_id]
      end
    
      results = trac.multicall(*calls)
      log "back in load_multiple_from_trac: results = #{results.size}"
    
      r = results.map do |result|
        log "init of ticket #{result[0].inspect}"
        Ticket.alloc.init(:id => result[0], :attributes => result[3])      
      end
    
      puts "tickets are built: #{r.size}"
      r
    end

    def log(msg)
      $stderr.puts msg
    end
  
    def query(query, callback=nil, selector=nil)
      if callback 
        Thread.new {
          ids = trac.ticket(:query, query)
          callback.performSelectorOnMainThread_withObject_waitUntilDone(selector, ids, true)
        }
        return []
      else
        trac.ticket(:query, query)
      end
    end
  
    def load_using_query(query, callback=nil, selector=nil)
      if callback 
        Thread.new {
          ids = trac.ticket(:query, query)[0..5]
          tickets = load_multiple(ids)
          $stderr.puts "Ticket.load_using_query: #{tickets.size}"
          return callback.performSelectorOnMainThread_withObject_waitUntilDone("#{selector.to_s}:", tickets, true)
        }
        return []
      else
        trac.ticket(:query, query)
      end
    end
  
    def load_new_tickets
      ids = trac.ticket(:query, 'status=new')
      load_multiple(ids)
    end
    
    def trac
      Trac.new('http://cmorss:cmorss@trac.local/vendo/login/xmlrpc')
    end
  
    def load_from_cache(id)
      Cache.get(id)
    end
    
    def observable(*attrs)
      attr_reader(:dirty)
            
      Array(attrs).each do |attr|
        define_method("#{attr}=") do |*args|
          old_value = send(attr)
          super
          @dirty = true
          (@observers || []).each {|o| o.observed_changed(self, attr, args.first, old_value)}        
        end      
      end
      
      define_method(:add_observer) do |observer|
        (@observers ||= []) << observer
      end

      define_method(:remove_observers) do
        @observers = nil
      end
    end
  end

  observable :ticket_id, :summary, :owner
  
	def init(opts)
	  super
	  @id = opts[:id]
	  self.attributes = opts[:attributes] || {}
	  self
	end

  def attributes=(attrs)
    attrs.keys.each do |attr|
      send("#{attr.to_sym}=", attrs[attr])
    end
  end    
end
