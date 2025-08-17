# frozen_string_literal: true

module RWC
  module Generators
    class InputGenerator < Rails::Generators::NamedBase
      QUERY_TYPE = "query"
      source_root File.expand_path("templates", __dir__)

      class_option :input_type, type: :string, default: "base",
                                desc: "One of query/create"

      def create_input_file
        source = query_input? ? "query_input.rb.tt" : "create_input.rb.tt"
        template(source, "app/inputs/#{class_name.underscore}.rb")
      end

      private

      def query_input?
        class_name.downcase.include?(QUERY_TYPE) || options[:input_type] == QUERY_TYPE
      end
    end
  end
end
