# frozen_string_literal: true

module GeneratorHelper
  def run_generator(klass, args, **opts)
    klass.new(args, [], **opts).invoke_all
  end
end

RSpec.configure do |config|
  config.include GeneratorHelper, type: :generator
end
