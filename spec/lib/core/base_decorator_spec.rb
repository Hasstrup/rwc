# frozen_string_literal: true

require "spec_helper"
require "fixtures/example_decorator"
require "ostruct"

RSpec.describe RWC::Core::BaseDecorator, type: :decorator do
  let(:obj) { double(a: 1, b: 3) }
  let(:decorator) { SimpleObjectDecorator.decorate(obj) }

  describe "computational methods" do
    it "decorates the object correctly" do
      expect(decorator.c).to eq(obj.a + obj.b)
    end
  end
end
