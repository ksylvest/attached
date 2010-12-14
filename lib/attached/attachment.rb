require 'guid'

require 'attached/storage'
require 'attached/processor'
require 'attached/resize'

module Attached
  
  class Attachment
    
    
    attr_reader :file
    attr_reader :name
    attr_reader :instance
    attr_reader :options
    attr_reader :queue
    attr_reader :path
    attr_reader :styles
    attr_reader :default
    attr_reader :medium
    attr_reader :credentials
    attr_reader :processors
    attr_reader :processor
    
    
    # A default set of options that can be extended to customize the path, storage or credentials.
    #
    # Usage:
    #
    #   Attached::Attachment.options = { :storage => :fs, :path => "/:name/:style/:identifier:extension" }
    
    def self.options
      @options ||= {
        :path       => "/:name/:style/:identifier:extension",
        :default    => :original,
        :styles     => {},
        :processors => [],
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
    # * :storage     - The storage medium represented as a symbol such as ':s3'
    # * :credentials - A file, hash, or path used to authenticate with the specified storage medium
    # * :styles      - A hash containing optional parameters including extension and identifier
    
    def initialize(name, instance, options = {})
      @name        = name
      @instance    = instance
      @options     = self.class.options.merge(options)
      
      @queue       = {}
      
      @path        = @options[:path]
      @styles      = @options[:styles]
      @default     = @options[:default]
      @medium      = @options[:medium]
      @credentials = @options[:credentials]
      @processors  = @options[:processors]
      @processor   = @options[:processor]
      
      @processors << @processor if @processor
    end
    
    
    # Check if an attachment has been modified.
    #
    # Usage:
    #
    #   @object.avatar.changed?
    
    def changed?
      instance.changed.include? "#{name}_identifier"
    end
    
    
    # Assign an attachment to a file.
    #
    # Usage:
    #
    #   @object.avatar.assign(...)
    
    def assign(file, identifier = Guid.new)
      @file = file.tempfile
      
      extension = File.extname(file.original_filename)
       
      instance_set :size, file.size
      instance_set :extension, extension
      instance_set :identifier, identifier
      
      self.queue[self.default] = self.file
      
      process()
    end
    
    
    # Save an attachment.
    #
    # Usage:
    #
    #   @object.avatar.save
    
    def save
      @storage ||= Attached::Storage.storage(self.medium, self.credentials)
      
      @queue.each do |style, file|
        @storage.save(file, self.path(style)) if file and self.path(style)
      end
    end
    
    
    # Destroy an attachment.
    #
    # Usage:
    #
    #   @object.avatar.destroy
    
    def destroy
      @storage ||= Attached::Storage.storage(self.medium, self.credentials)
      
      @storage.destroy(self.path) if self.path
    end
    
    
    # Acesss the URL for an attachment.
    #
    # Usage:
    #
    #   @object.avatar.url
    #   @object.avatar.url(:small)
    #   @object.avatar.url(:large)
    
    def url(style = self.default)
      @storage ||= Attached::Storage.storage(self.medium, self.credentials)
      
      return "#{@storage.host}#{path(style)}"
    end
    
    
    # Access the path for an attachment. 
    #
    # Usage:
    #
    #   @object.avatar.url
    #   @object.avatar.url(:small)
    #   @object.avatar.url(:large)
    
    def path(style = self.default)
      path = @path.clone
      
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
    
    def extension(style = nil)
      style and
      self.styles and 
      self.styles[style] and 
      self.styles[style][:extension] or 
      instance_get(:extension)
    end
    
    
    # Access the identifier for an attachment. It will first check the styles 
    # to see if one is specified before checking the instance.
    #
    # Usage:
    #
    # @object.avatar.identifier
    
    def identifier(style = nil)
      style and
      self.styles and 
      self.styles[style] and 
      self.styles[style][:identifier] or 
      instance_get(:identifier)
    end
    
    
    # Set the extension for an attachment. It will act independently of the 
    # defined style.
    #
    # Usage:
    #
    # @object.avatar.extension = ".png"
    
    def extension=(extension)
      instance_set(:extension, extension)
    end
    
    # Set the identifier for an attachment. It will act independently of the 
    # defined style.
    #
    # Usage:
    #
    # @object.avatar.identifier = "1234"
    
    def identifier=(identifier)
      instance_set(:identifier, identifier)
    end
    
    
  private
  
    # Helper function for calling processors.
    #
    # Usage:
    #
    #   self.process
    
    def process
      @processors.each do |processor|
        self.styles.each do |style, options|
          self.queue[style] = Attached::Resize.process(self.queue[style] || self.file, options, self)
        end
      end
    end
  
  
    # Helper function for setting instance variables.
    # 
    # Usage:
    #
    #   self.instance_set(size, 12345)
  
    def instance_set(attribute, value)
      setter = :"#{self.name}_#{attribute}="
      self.instance.send(setter, value) if instance.respond_to?(setter)
    end
    
    
    # Helper function for getting instance variables.
    #
    # Usage:
    #
    # self.instance_get(size)
    
    def instance_get(attribute)
      getter = :"#{self.name}_#{attribute}"
      self.instance.send(getter) if instance.respond_to?(getter)
    end

    
  end
  
end