# frozen_string_literal: true

require "rwc/core/base_decorator"

class SimpleObjectDecorator < Rwc::Core::BaseDecorator
  delegate_all

  def c
    a + b
  end
end
