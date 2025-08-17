# frozen_string_literal: true

require "rails/generators"

module RWC
  module Generators
    class ServiceGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_service_file
        template "service.rb.tt", "app/services/#{class_name.underscore}.rb"
      end
    end
  end
end
