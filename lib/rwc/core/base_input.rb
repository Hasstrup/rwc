# frozen_string_literal: true

require_relative "concerns/validation"
require "ostruct"

module Rwc
  module Core
    # Represents a base input class for handling and validating input data.
    class BaseInput
      class InputValidationError < StandardError; end

      include Concerns::Validation

      class << self
        attr_reader :fields, :target

        # Defines the attributes that the input class can accept.
        #
        # @param [Symbol] args The attributes to be defined for the input.
        def attributes(*args)
          @fields = args
        end

        # Specifies the target class for polymorphic associations.
        #
        # @param [Class] target_klass The target class for validation.
        def input_for(target_klass)
          @target = target_klass
        end
      end

      attr_reader :errors

      # Initializes a new BaseInput instance.
      #
      # @param [Hash] kwargs The keyword arguments for the input.
      # @option kwargs [Object] :context Additional context for the input validation.
      def initialize(**kwargs)
        @input = OpenStruct.new(**kwargs.except(:context))
        @context = kwargs[:context]
        @valid = false
        @errors = []
      end

      # Returns human-readable error messages from the errors array.
      #
      # @return [String] The humanized error messages.
      def humanized_error_messages
        errors.map(&:message).join(", ")
      end

      # Delegates method calls to the input object.
      #
      # @param [Symbol] name The method name to be called.
      # @param [Array] _args The arguments to be passed to the method.
      # @return [Object] The result of the method call on the input object.
      def method_missing(name, *_args)
        input.send(name)
      end

      # Checks if the method is respondable based on defined attributes.
      #
      # @param [Symbol] name The method name.
      # @param [Boolean] _include_private Whether to include private methods.
      # @return [Boolean] True if the method is respondable; otherwise, false.
      def respond_to_missing?(name, _include_private = false)
        self.class.attributes.include?(name)
      end

      # Fetches a value from the input as a hash.
      #
      # @param [Array] args The keys to fetch values for.
      # @return [Object] The fetched value.
      def fetch(*args)
        to_h.fetch(*args)
      end

      # Slices the input to return only specified keys.
      #
      # @param [Array] args The keys to slice from the input.
      # @return [Hash] A hash containing only the specified keys.
      def slice(*args)
        to_h.slice(*args)
      end

      def to_h(*args)
        input.to_h(*args)
      end

      private

      attr_reader :input, :valid, :context
    end
  end
end
