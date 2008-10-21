module Observable
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
