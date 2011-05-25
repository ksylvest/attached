require 'attached/storage/base'

module Attached
	module Storage
		class Local < Base
			
			
			attr_reader :mode
			
			
			# Create a new interface supporting save and destroy operations.
			#
			# Usage:
			#
			#		Attached::Storage::Local.new()
			
			def initialize()
				@mode = 0644
			end
			
			
			# Access the host (e.g. /system/) for a storage service.
			#
			# Usage:
			#
			#		storage.host
			
			def host()
			  "/system/"
			end
			
			
      # Save a file to a given path.
      #
      # Parameters:
      #
      # * file - The file to save.
      # * path - The path to save.
      
      def save(file, path)
        path = "#{Rails.root}/public/system/#{path}"
        dirname, basename = File.split(path)
        
        return if file.path == path
        
        begin
          FileUtils.mkdir_p(dirname)
          FileUtils.cp(file.path, path)
          FileUtils.chmod(self.mode, path)
        rescue Errno::ENOENT
        end
      end
      
      
      # Destroy a file at a given path.
      #
      # Parameters:
      #
      # * path - The path to destroy.
      
      def destroy(path)
        path = "#{Rails.root}/public/system/#{path}"
        dirname, basename = File.split(path)
    
        begin
          FileUtils.rm(path)
        rescue Errno::ENOENT
        end
      end
      
			
		end
	end
end