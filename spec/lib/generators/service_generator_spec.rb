# frozen_string_literal: true

require "tmpdir"
require "spec_helper"
require "rwc/generators/service_generator"

RSpec.describe RWC::Generators::ServiceGenerator, type: :generator do
  let(:destination_root) { Dir.mktmpdir }

  after do
    FileUtils.rm_rf(destination_root)
  end
  describe "generating a service with the correct template" do
    it "creates a service file with the correct content" do
      run_generator(described_class, ["ExampleVService"], destination_root: destination_root)
      content = File.read(File.join(destination_root, "app/services/example_V_service.rb"))

      aggregate_failures do
        expect(content).to include("class ExampleVService < RWC::Core::BaseService")
        expect(content).to include("def call")
        expect(content).to include("safely_execute do")
      end
    end
  end
end
