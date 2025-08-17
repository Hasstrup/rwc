require "rwc/core/context"
require "rwc/core/concerns/error_handling"

# BaseService serves as a foundational class for creating service objects
# in the application. It provides a standardized interface for service calls
# and integrates error handling mechanisms.
module RWC
  module Core
    class BaseService
      include Concerns::ErrorHandling::Validatable

      # Calls the service with the provided keyword arguments.
      #
      # @param [Hash] kwargs The keyword arguments to be passed to the service.
      # @return [Object] The result of the service call.
      def self.call(**kwargs)
        new(**kwargs).call
      end

      # Executes the service logic. Must be implemented in subclasses.
      #
      # @raise [NotImplementedError] When not implemented in a subclass.
      def call
        raise NotImplementedError
      end

      delegate :fail!, :succeed, to: :context

      private

      attr_reader :input

      # Initializes the context for the service.
      #
      # @return [Context] The service context.
      def context
        @context ||= Context.new
      end
    end
  end
end
