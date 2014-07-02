require 'attached/definition'
require 'attached/attachment'
require 'attached/attatcher'
require 'attached/railtie'

module Attached

  def self.mock!
    Fog.mock!
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # Add an attachment to a class.
    #
    # Options:
    #
    # * :styles    - a hash containing style names followed by parameters passed to processor
    # * :storage   - a symbol for a predefined storage or a custom storage class
    # * :processor - a symbol for a predefined processor or a custom processor class
    #
    # Usage:
    #
    #   has_attached :video
    #   has_attached :video, storage: :aws
    #   has_attached :video, styles: { mov: { size: "480p", format: "mov" } }

    def has_attached(name, options = {})
      Attatcher.define(self, name, options)
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
    #   validates_attached_size :avatar, range: 10.megabytes .. 20.megabytes
    #   validates_attached_size :avatar, minimum: 10.megabytes, maximum: 20.megabytes
    #   validates_attached_size :avatar, message: "size must be between :minimum and :maximum bytes"

    def validates_attached_size(name, options = {})

      zero = (0.0 / 1.0)
      infi = (1.0 / 0.0)

      minimum = options[:minimum] || options[:in] && options[:in].first || zero
      maximum = options[:maximum] || options[:in] && options[:in].last  || infi

      message = options[:message]
      message ||= "size must be specified" if minimum == zero && maximum == infi
      message ||= "size must be a minimum of :minimum" if maximum == infi
      message ||= "size must be a maximum of :maximum" if minimum == zero
      message ||= "size must be between :minimum and :maximum"

      range = minimum..maximum

      message.gsub!(/:minimum/, number_to_size(minimum)) unless minimum == zero
      message.gsub!(/:maximum/, number_to_size(maximum)) unless maximum == infi

      validates_inclusion_of :"#{name}_size", in: range, message: message,
        if: options[:if], unless: options[:unless]

    end

    # Validates an attached extension in a specified set.
    #
    # Options:
    #
    # * :in - allowed values for attached
    #
    # Usage:
    #
    #   validates_attached_extension :avatar, is: 'png'
    #   validates_attached_extension :avatar, in: %w(png jpg)
    #   validates_attached_extension :avatar, in: [:png, :jpg]
    #   validates_attached_extension :avatar, in: %w(png jpg), message: "extension must be :in"
    #   validates_attached_extension :avatar, in: %w(png jpg), message: "extension must be :in"

    def validates_attached_extension(name, options = {})

      message = options[:message]
      message ||= "extension is invalid"

      options[:in] ||= [options[:is]] if options[:is]

      range = options[:in].map { |element| ".#{element}" }

      validates_inclusion_of :"#{name}_extension", in: range, message: message,
        if: options[:if], unless: options[:unless]
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
    #   validates_attached_presence :avatar, message: "must be attached"

    def validates_attached_presence(name, options = {})

      message = options[:message]
      message ||= "must be attached"

      validates_presence_of :"#{name}_identifier", message: message,
        if: options[:if], unless: options[:unless]

    end

  private

    # Convert a number to a human readable size.
    #
    # Usage:
    #
    #   number_to_size(1) # 1 byte
    #   number_to_size(2) # 2 bytes
    #   number_to_size(1024) # 1 kilobyte
    #   number_to_size(2048) # 2 kilobytes

    def number_to_size(number, options = {})
      return if number == 0.0 / 1.0
      return if number == 1.0 / 0.0

      singular = options['singular'] || 1
      base     = options['base']     || 1024
      units    = options['units']    || ["byte", "kilobyte", "megabyte", "gigabyte", "terabyte", "petabyte"]

      exponent = (Math.log(number) / Math.log(base)).floor

      number /= base ** exponent
      unit = units[exponent]

      number == singular ?  unit.gsub!(/s$/, '') : unit.gsub!(/$/, 's')

      "#{number} #{unit}"
    end

  end

end