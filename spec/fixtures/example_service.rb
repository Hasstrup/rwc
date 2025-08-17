# frozen_string_literal: true

require "rwc/core/base_service"

class BasicExampleServiceWithInputValidation < Rwc::Core::BaseService
  performs_checks

  def initialize(input:)
    @input = input
  end

  def call
    safely_execute do
      succeed(trigger)
    end
  end

  def trigger; end
end
