require 'attached/attachment'
require 'attached/railtie'


module Attached  
  
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  
  module ClassMethods
    
    
    # Initialize attached options used for communicating between class and instance methods.
    
    def initialize_attached_options
      write_inheritable_attribute(:attached_options, {})
    end
    
    
    # Access attached options used for communicating between class and instance methods.
    
    def attached_options
      read_inheritable_attribute(:attached_options)
    end
    
    
    # Add an attachment to a class.
    #
    # Options:
    #
    # * :styles  - 
    # * :storage - 
    #
    # Usage:
    #
    #   has_attached :video
    #   has_attached :video, :storage => :s3
    #   has_attached :video, styles => [ :mp4, :ogv ]
    #   has_attached :video, styles => { :main => { :size => "480p", :format => "mp4" } }
    #   has_attached :thumbnail, :range => (1..4)
    
    def has_attached(name, options = {})
      
      include InstanceMethods
      
      initialize_attached_options unless attached_options
      attached_options[name] = options
      
      before_save :save_attached
      before_destroy :destroy_attached
      
      define_method name do
        attachment_for(name)
      end
      
      define_method "#{name}=" do |file|
        attachment_for(name).assign(file)
      end

      define_method "#{name}?" do
        attachment_for(name).file?
      end
      
      after_validation do
        
        self.errors[:"#{name}_size"].each do |message|
          self.errors.add(name, message)
        end
        
        self.errors[:"#{name}_extension"].each do |message|
          self.errors.add(name, message)
        end
        
        self.errors[:"#{name}_identifier"].each do |message|
          self.errors.add(name, message)
        end
        
        self.errors.delete(:"#{name}_size")
        self.errors.delete(:"#{name}_extension")
        self.errors.delete(:"#{name}_identifier")
        
      end
      
    end
    
    
    # Validates an attached size in a specified range or minimum and maximum. 
    #
    # Options:
    #
    # * :message - string to be displayed with :minimum and :maximum variables
    # * :minimum - integer for the minimum byte size of the attached
    # * :maximum - integer for the maximum byte size of teh attached
    # * :in - range of bytes for file
    #
    # Usage:
    #   
    #   validates_attached_size :avatar, :range => 10.megabytes .. 20.megabytes
    #   validates_attached_size :avatar, :minimum => 10.megabytes, :maximum => 20.megabytes
    #   validates_attached_size :avatar, :message => "size must be between :minimum and :maximum bytes"
    
    def validates_attached_size(name, options = {})
      
      message = options[:message] || "size must be between :minimum and :maximum"
       
      minimum = options[:minimum] || options[:in] && options[:in].first || (0.0 / 1.0)
      maximum = options[:maximum] || options[:in] && options[:in].last  || (1.0 / 0.0)
       
      range = minimum..maximum
      
      message.gsub!(/:minimum/, number_to_human_size(minimum))
      message.gsub!(/:maximum/, number_to_human_size(maximum))
      
      validates_inclusion_of :"#{name}_size", :in => range, :message => message, 
        :if => options[:if], :unless => options[:unless]
      
    end
    
    
    # Validates that an attachment is included.
    #
    # Options:
    #
    # * :message - string to be displayed
    #
    # Usage:
    #
    #   validates_attached_presence :avatar
    #   validates_attached_presence :avatar, :message => "must be attached"
    
    def validates_attached_presence(name, options = {})
      
      message = options[:message] || "must be attached"
      
      validates_presence_of :"#{name}_identifier", :message => message,
        :if => options[:if], :unless => options[:unless]
      
    end
    
    
  end
  
  
  module InstanceMethods
    
    
    # Create or access attachment.
    #
    # Usage:
    # 
    #    attachment_for :avatar
    
    def attachment_for(name)
      @_attached_attachments ||= {}
      @_attached_attachments[name] ||= Attachment.new(name, self, self.class.attached_options[name])
    end
    
    
    # Log and save all attached (using specified storage).
    #
    # Usage:
    #
    #   before_save :save_attached
    
    def save_attached
      logger.info "[attached] save attached"
      
      self.class.attached_options.each do |name, options| 
        attachment_for(name).save
      end
    end
    
    
    # Log and destroy all attached (using specified storage).
    #
    # Usage:
    #
    #   before_save :destroy_attached
    
    def destroy_attached
      logger.info "[attached] destroy attached"
      
      self.class.attached_options.each do |name, options|
        attachment_for(name).destroy
      end
    end
    
    
  end
  
  
end