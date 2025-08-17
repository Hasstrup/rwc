# frozen_string_literal: true

require "spec_helper"
require "active_record"
require "rwc/core/base_service"
require "rwc/core/base_input"
require "fixtures/example_service"

RSpec.describe RWC::Core::BaseService do
  let(:service) { BasicExampleServiceWithInputValidation.new(input: input) }
  let(:input) { instance_double(RWC::Core::BaseInput, valid?: input_validation_context, errors: []) }
  let(:context) { service.call }

  context "when given valid input" do
    let(:input_validation_context) { true }
    let(:expected_payload) { { payload: [] } }
    before { allow(service).to receive(:trigger).and_return(expected_payload) }

    it "is successful" do
      aggregate_failures do
        expect(context.success?).to be(true)
        expect(context.payload).to eq(expected_payload)
      end
    end
  end

  context "with an invalid input" do
    let(:input_validation_context) { false }
    let(:context) { service.call }

    it "is unsuccessful" do
      expect(context.success?).to be(false)
    end

    it "contains the errors in the message" do
      expect(context.errors).to include(RWC::Core::Concerns::ErrorHandling::InvalidInputError)
    end
  end

  context "when a (safely nested) error occurs during execution" do
    let(:input_validation_context) { true }
    let(:service_error) { RWC::Core::Concerns::ErrorHandling::Core::ERROR_CLASSES.sample }

    before do
      allow(service).to receive(:trigger).and_raise(service_error)
    end

    it "is unsuccessful" do
      expect(context.success?).to be(false)
    end

    it "fails with the correct error" do
      expect(context.errors).to include(service_error)
    end
  end
end
