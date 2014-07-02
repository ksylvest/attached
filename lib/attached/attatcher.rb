module Attached

  class Attatcher

    attr_reader :klass
    attr_reader :name
    attr_reader :options

    def initialize(klass, name, options = {})
      @klass = klass
      @name = name
      @options = options
    end

    def self.define(klass, name, options = {})
      new(klass, name, options).define
    end

    # Define the model methods required to run.
    #
    # Usage:
    #
    #   attacher.define

    def define
      saving
      destroying
      getters
      setters
      query
      url
      validations
      flusher
    end

    # Define the saving callbacks.
    #
    # Usage:
    #
    #   attacher.saving

    def saving
      name = @name
      @klass.send(:before_save) do
        logger.info "[attached] saving #{name}"
        send(name).save
      end
    end

    # Define the destroying callbacks.
    #
    # Usage:
    #
    #   attacher.destroying

    def destroying
      name = @name
      @klass.send(:before_destroy) do
        logger.info "[attached] destroying #{name}"
        send(name).destroy
      end
    end

    # Define the getter.
    #
    # Usage:
    #
    #   attacher.getters

    def getters
      name = @name
      options = @options
      @klass.send(:define_method, name) do
        ivar = :"@_attachment_#{name}"
        attachment = instance_variable_get(ivar)

        if attachment.nil?
          attachment = Attachment.new(name, self, options)
          instance_variable_set(ivar, attachment)
        end

        return attachment
      end
    end

    # Define the setter.
    #
    # Usage:
    #
    #   attacher.setters

    def setters
      name = @name
      @klass.send(:define_method, "#{name}=") do |file|
        send(name).assign(file)
      end
    end

    # Define the query.
    #
    # Usage:
    #
    #   attacher.getters

    def query
      name = @name
      @klass.send(:define_method, "#{name}?") do
        send(name).attached?
      end
    end

    # Define the URL.
    #
    # Usage:
    #
    #   attacher.getters

    def url
      name = @name
      @klass.send(:define_method, "#{name}_url=") do |url|
        send(name).url = url
      end
    end

    # Forward validations.
    #
    # Usage:
    #
    #   attacher.validations

    def validations
      name = @name
      @klass.send(:validates_each, name) do |record, attr, value|
        record.send(name).errors.each do |error|
          record.errors.add(name, error)
        end
      end
    end

    # Flush validations.
    #
    # Usage:
    #
    #   attacher.flusher

    def flusher
      name = @name
      [:before_validation,:after_validation].each do |operation|
        @klass.send(operation) do

          %w(size extension identifier).each do |attribute|
            if errors.include?(:"#{name}_#{attribute}")
              errors[:"#{name}_#{attribute}"].each do |message|
                errors.add(name, message)
              end
              errors[:"#{name}_#{attribute}"].clear
            end
          end
        end
      end
    end

  end

end
