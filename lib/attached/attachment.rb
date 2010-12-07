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
        :storage  => :fs,
        :protocol => 'http',
        :path     => "/:name/:style/:id:extension",
        :styles   => {},
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
    # * :path        - The location where the attachment is stored
    # * :storage     - The storage medium represented as a symbol such as ':s3' or ':fs'
    # * :credentials - A file, hash, or path used to authenticate with the specified storage medium
    
    def initialize(name, instance, options = {})
      @name       = name
      @instance   = instance
      
      @options    = self.class.options.merge(options)
    end
    
    
    # Usage:
    #
    #   @object.avatar.assign(...)
    
    def assign(file, identifier = UUID.generate)
      @file = file
      
      extension = File.extname(file.original_filename)
      
      instance_set :size, file.size
      instance_set :extension, extension
      instance_set :identifier, identifier
    end
    
    
    # Usage:
    #
    #   @object.avatar.save
    
    def save
      @storage ||= Attached::Storage.medium(options[:storage], options[:credentials])
      
      storage.save(self.file, self.path) if self.file
    end
    
    
    # Usage:
    #
    #   @object.avatar.destroy
    
    def destroy
      @storage ||= Attached::Storage.medium(options[:storage], options[:credentials])
      
      storage.destroy(self.path)
    end
    
    # Acesss the URL for an attachment.
    #
    # Usage:
    #
    #   @object.avatar.url
    #   @object.avatar.url(:small)
    #   @object.avatar.url(:large)
    
    def url(style, options = {})
      @storage ||= Attached::Storage.medium(options[:storage], options[:credentials])
      
      return "#{options[:protocol]}://#{@storage.host}#{path(style)}"
    end
    
    
    # Access the path for an attachment. 
    #
    # Usage:
    #
    #   @object.avatar.url
    #   @object.avatar.url(:small)
    #   @object.avatar.url(:large)
    
    def path(style, options = {})
      path = options[:path].clone
      
      path.gsub!(/:name/, name.to_s)
      path.gsub!(/:style/, style.to_s)
      path.gsub!(/:extension/, extension(style).to_s)
      path.gsub!(/:identifier/, identifier(style).to_s)

      return path
    end
    
    # Access the size for an attachment.
    #
    # Usage:
    #
    # @object.avatar.size
    
    def size
      return instance_get(:size)
    end
    
    
    # Access the extension for an attachment. It will first check the styles 
    # to see if one is specified before checking the instance.
    #
    # Usage:
    #
    # @object.avatar.extension
    
    def extension(style)
      options[:styles] and 
      options[:styles][style] and 
      options[:styles][style][:extension] or 
      instance_get(:extension)
    end
    
    # Access the identifier for an attachment. It will first check the styles 
    # to see if one is specified before checking the instance.
    #
    # Usage:
    #
    # @object.avatar.identifier
    
    def identifier(style)
      options[:styles] and 
      options[:styles][style] and 
      options[:styles][style][:identifier] or 
      instance_get(:identifier)
    end
    
  private
  
  
    # Helper function for setting instance variables.
    # 
    # Usage:
    #
    #   self.instance_set(size, 12345)
  
    def instance_set(attribute, value)
      setter = :"#{self.name}_#{attribute}="
      self.instance.send(setter, value)
    end
    
    
    # Helper function for getting instance variables.
    #
    # Usage:
    #
    # self.instance_get(size)
    
    def instance_get(attribute)
      getter = :"#{self.name}_#{attribute}"
      self.instance.send(getter)
    end

    
  end
  
end