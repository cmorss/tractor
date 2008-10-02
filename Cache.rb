#
#  Cache.rb
#  Tractor
#
#  Created by Charlie Morss on 9/10/08.
#  Copyright (c) 2008 AdReady. All rights reserved.
#

class Cache
  class << self

    def ensure_cache_directory
      storeFolder = applicationSupportDirectory
      mkdir(storeFolder)
    end
    
    def applicationSupportDirectory
      OSX.NSHomeDirectory.stringByAppendingPathComponent(File.join('Library', 'Application Support', 'Tractor'))
    end
    
    def ticket_dir(id)
      File.join(applicationSupportDirectory, "00#{id}"[-2..-1])
    end
    
    def ticket_file_name(id)
      File.join(ticket_dir(id), id.to_s)
    end
      
    def mkdir(directory)
      fileManager = OSX::NSFileManager.defaultManager
      unless fileManager.fileExistsAtPath_isDirectory(directory, nil)
        fileManager.createDirectoryAtPath_attributes(directory, nil)
      end    
    end
    
    def put(id, obj)
      ensure_directory(id)
      File.open(ticket_file_name(id),'w') do |f|
        Marshal.dump(obj, f)
      end      
    end

    def get(id)
      obj = nil
      
      if cached(id)
        File.open(ticket_file_name(id),'r') do |f|
          obj = Marshal.load(f)
        end
      end      
      obj
    end

    def cached(id)
      ensure_directory(id)
      path = ticket_file_name(id)
      fileManager = OSX::NSFileManager.defaultManager
      fileManager.fileExistsAtPath(path)
    end
    
    def ensure_directory(id)
      dir = ticket_dir(id)
      mkdir(dir)
      dir
    end
    
    def log(msg)
      $stderr.puts msg
    end
  end
end
