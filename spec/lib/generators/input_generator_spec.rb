# frozen_string_literal: true

require "tmpdir"
require "spec_helper"
require "rwc/generators/input_generator"

RSpec.describe RWC::Generators::InputGenerator, type: :generator do
  let(:destination_root) { Dir.mktmpdir }

  after do
    FileUtils.rm_rf(destination_root)
  end

  describe "generating a input file with the correct template" do
    context "when generating a create input" do
      it "creates the right input file" do
        run_generator(described_class, ["V1::Core::CreateInput"], destination_root: destination_root)
        content = File.read(File.join(destination_root, "app/inputs/v1/core/create_input.rb"))

        aggregate_failures do
          expect(content).to include("class V1::Core::CreateInput < RWC::Core::BaseInput")
          expect(content).to include("REQUIRED_KEYS")
          expect(content).to include("attributes()")
        end
      end
    end

    context "when generating a query input" do
      it "creates the right query input file" do
        run_generator(described_class, ["V1::Core::QueryInput"], destination_root: destination_root)
        content = File.read(File.join(destination_root, "app/inputs/v1/core/query_input.rb"))

        aggregate_failures do
          expect(content).to include("class V1::Core::QueryInput < RWC::Core::Queries::SimpleInput")
          expect(content).to include("input_for")
        end
      end
    end
  end
end
