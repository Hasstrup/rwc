# frozen_string_literal: true

module RWC
  module Generators
    class DecoratorGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_decorator_file
        template "decorator.rb.tt", "app/decorators/#{class_name.underscore}.rb"
      end
    end
  end
end
