require 'uuid'

require 'attached/storage'

module Attached
  
  class Attachment
    
    
    attr_reader :file
    attr_reader :name
    attr_reader :instance
    attr_reader :options
    attr_reader :storage
    
    
    def self.options
      @options ||= {
        :storage => :fs,
        :path => "/:name/:style/:uuid.:extension"
      }
    end
    
    
    # Initialize a new attachment by providing a name and the instance the attachment is associated with.
    #
    # Parameters:
    # 
    # * name        - The name for the attachment such as 'avatar' or 'photo'
    # * instance    - The instance the attachment is attached to
    #
    # Options:
    #
    # * path        - The location where the attachment is stored
    # * storage     - The storage medium represented as a symbol such as ':s3' or ':fs'
    # * credentials - A file, hash, or path used to authenticate with the specified storage medium
    
    def initialize(name, instance, options = {})
      @name       = name
      @instance   = instance
      
      @options    = self.class.options.merge(options)
    end
    
    
    # Usage:
    #
    #   @object.avatar.assign(...)
    
    def assign(file)
      @file = file
      
      instance_set(:attached_uuid, UUID.generate)
      instance_set(:attached_size, file.size)
    end
    
    
    # Usage:
    #
    #   @object.avatar.save
    
    def save
      @storage ||= Attached::Storage.medium(options[:storage], options[:credentials])
      
      storage.save(self.file, self.path)
    end
    
    
    # Usage:
    #
    #   @object.avatar.destroy
    
    def destroy
      @storage ||= Attached::Storage.medium(options[:storage], options[:credentials])
      
      storage.destroy(self.path)
    end
    
    
    # Usage:
    #
    #   @object.avatar.url
    #   @object.avatar.url(:small)
    #   @object.avatar.url(:large)
    
    def url(style = :original)
      return path(style)
    end
    
    
    # Access the URL 
    #
    # Usage:
    #
    #   @object.avatar.url
    #   @object.avatar.url(:small)
    #   @object.avatar.url(:large)
    
    def path(style = :original)
      path = options[:path]
      path.gsub!(/:name/, name.to_s)
      path.gsub!(/:uuid/, uuid.to_s)
      path.gsub!(/:style/, style.to_s)

      return path
    end
    
    # Access the size for an attachment.
    #
    # Usage:
    #
    # @object.avatar.size
    
    def size
      instance_get(:attached_size)
    end
    
    
    # Access the uuid for an attachment.
    #
    # Usage:
    #
    # @object.avatar.uuid
    
    def uuid
      instance_get(:attached_uuid)
    end
    
    
    # Access the extension for an attachment.
    #
    # Usage:
    #
    # @object.avatar.extension
    
    def extension
      instance_get(:attached_extension)
    end
    
    
  private
  
  
    # Helper function for setting instance variables.
    # 
    # Usage:
    #
    #   self.instance_set(attached_size, 12345)
  
    def instance_set(attribute, value)
      setter = :"#{self.name}_#{attribute}="
      self.instance.send(setter, value)
    end
    
    
    # Helper function for getting instance variables.
    #
    # Usage:
    #
    # self.instance_get(attached_size)
    
    def instance_get(attribute)
      getter = :"#{self.name}_#{attribute}"
      self.instance.send(getter)
    end

    
  end
  
end