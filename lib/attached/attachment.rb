require 'guid'

require 'attached/storage'
require 'attached/storage/error'

require 'attached/processor'
require 'attached/processor/error'

module Attached
  
  class Attachment
    
    
    attr_reader :file
    attr_reader :name
    attr_reader :instance
    attr_reader :queue
    attr_reader :purge
    attr_reader :errors
    attr_reader :path
    attr_reader :styles
    attr_reader :default
    attr_reader :medium
    attr_reader :credentials
    attr_reader :processors
    attr_reader :processor
    attr_reader :aliases
    attr_reader :alias
    attr_reader :storage
    attr_reader :host
    
    
    # A default set of options that can be extended to customize the path, storage or credentials.
    #
    # Usage:
    #
    #   Attached::Attachment.options = { :storage => :fs, :path => ":name/:style/:identifier:extension" }
    
    def self.options
      @options ||= {
        :path        => ":name/:style/:identifier:extension",
        :default     => :original,
        :medium      => :aws,
        :credentials => {},
        :styles      => {},
        :processors  => [],
        :aliases     => [],
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
    # * :styles      - A hash containing optional parameters including extension and identifier
    # * :credentials - A file, hash, or path used to authenticate with the specified storage medium
    # * :medium      - A symbol or subclass of 'Attached::Storage::Base' to be used
    # * :processor   - A symbol or subclass of 'Attached::Processor::Base' to be used
    # * :alias       - A string representing a fully qualified host alias
    # * :processors  - An array of processors 
    # * :aliases     - An array of aliases
    
    def initialize(name, instance, options = {})
      options      = self.class.options.merge(options)
      
      @name        = name
      @instance    = instance
      
      @queue = {}
      @purge = []
      @errors = []
      
      @path        = options[:path]
      @styles      = options[:styles]
      @default     = options[:default]
      @medium      = options[:medium]
      @credentials = options[:credentials]
      @processors  = options[:processors]
      @processor   = options[:processor]
      @aliases     = options[:aliases]
      @alias       = options[:alias]
      
      @processors  = self.processors + [self.processor] if self.processor
      @aliases     = self.aliases + [self.alias] if self.alias
      
      @storage     = Attached::Storage.storage(self.medium, self.credentials)
      
      @host        = self.storage.host
    end
    
    
    # Check if an attachment has been modified.
    #
    # Usage:
    #
    #   @object.avatar.changed?
    
    def changed?
      instance.changed.include? "#{name}_identifier"
    end
    
    def file?
      not identifier.blank?
    end
    
    
    # Assign an attachment to a file.
    #
    # Usage:
    #
    #   @object.avatar.assign(...)
    
    def assign(file, identifier = "#{Guid.new}")
      @file = file.respond_to?(:tempfile) ? file.tempfile : file
      
      extension ||= File.extname(file.original_filename) if file.respond_to?(:original_filename)
      extension ||= File.extname(file.path) if file.respond_to?(:path)
      
      @purge = [self.path, *self.styles.map { |style, options| self.path(style) }] if file?
      
      instance_set :size, file.size
      instance_set :extension, extension
      instance_set :identifier, identifier
      
      process
    end
    
    
    # Save an attachment.
    #
    # Usage:
    #
    #   @object.avatar.save
    
    def save
      self.purge.each do |path|
        self.storage.destroy(path)
      end
      
      self.queue.each do |style, file|
        path = self.path(style)
        self.storage.save(file, path) if file and path
      end
      
      @purge = []
      @queue = {}
    end
    
    
    # Destroy an attachment.
    #
    # Usage:
    #
    #   @object.avatar.destroy
    
    def destroy
      if file?
        self.storage.destroy(self.path)
        self.styles.each do |style, options|
          self.storage.destroy(self.path(style))
        end
      end
      
      @purge = []
      @queue = {}
    end
    
    
    # Acesss the URL for an attachment.
    #
    # Usage:
    #
    #   @object.avatar.url
    #   @object.avatar.url(:small)
    #   @object.avatar.url(:large)
    
    def url(style = self.default)
      path = self.path(style)
      
      host = self.host
      host = self.aliases[path.hash % self.aliases.count] unless self.aliases.empty?
      
      return "#{host}#{path}"
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
    
    
    # Todo.
    
    def reprocess!
    end
    
    
  private
    
  
    # Helper function for calling processors (will queue default).
    #
    # Usage:
    #
    #   self.process
    
    def process
      self.queue[self.default] = self.file
              
      begin
      
        self.processors.each do |processor|
          processor = Attached::Processor.processor(processor)
          self.styles.each do |style, options|
            self.queue[style] = processor.process(self.queue[style] || self.file, options, self)
          end
        end
        
      rescue Attached::Processor::Error => error
        self.errors << error.message
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