# frozen_string_literal: true

require "tmpdir"
require "spec_helper"
require "generators/rwc/decorator/decorator_generator"

RSpec.describe Rwc::DecoratorGenerator, type: :generator do
  let(:destination_root) { Dir.mktmpdir }

  after do
    FileUtils.rm_rf(destination_root)
  end

  describe "generating a decorator file with the correct template" do
    it "creates the decorator file with the correct content" do
      run_generator(described_class, ["V1::Core::MyModelDecorator"], destination_root: destination_root)
      content = File.read(File.join(destination_root, "app/decorators/v1/core/my_model_decorator.rb"))

      aggregate_failures do
        expect(content).to include("class V1::Core::MyModelDecorator < Rwc::Core::BaseDecorator")
        expect(content).to include("delegate_all")
      end
    end
  end
end
