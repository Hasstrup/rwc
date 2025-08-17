# frozen_string_literal: true

require_relative "rwc/version"
require "rwc/generators/service_generator"
require "rwc/generators/input_generator"
require "rwc/generators/decorator_generator"
require "rwc/core/base_service"
require "rwc/core/base_input"
require "rwc/core/base_decorator"

module RWC
  class Error < StandardError; end
  # Your code goes here...
end
