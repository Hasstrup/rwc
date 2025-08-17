# frozen_string_literal: true

module Rwc
  module Queries
    class SimpleInput
      attr_reader :params

      class << self
        attr_reader :target_klass

        def input_for(klass)
          @target_klass = klass
        end
      end

      def initialize(fields:, type: :group, **context)
        @params = fields
        @type = type
        @_context = context || {}
      end

      def conditions
        params.slice(*valid_fields)
      end

      def includes
        params.dig(:includes)&.map(&:to_sym) & valid_includes
      end

      def context
        @context ||= OpenStruct.new(**@_context)
      end

      def sanitize!
        # for now just remove nil keys
        params.compact!
        self
      end

      def single?
        type == :single
      end

      def __raw__
        OpenStruct.new(**params)
      end

      private

      attr_reader :type

      def valid_fields
        self.class.target_klass.attribute_names.map(&:to_sym)
      end

      def valid_includes
        self.class.target_klass.reflect_on_all_associations.map(&:name)
      end
    end
  end
end
