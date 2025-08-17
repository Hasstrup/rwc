# frozen_string_literal: true

require "spec_helper"
require "fixtures/example_input"

RSpec.describe Rwc::Core::BaseInput, type: :input do
  let(:input) { BasicExampleInput.new(**params) }
  let(:core_params) do
    BasicExampleInput::REQUIRED_KEYS.each_with_object({}) do |nxt, acc|
      acc[nxt] = true
    end
  end
  before { input.validate! }

  context "validations" do
    describe "#validate_required_keys" do
      let(:missing_param) { BasicExampleInput::REQUIRED_KEYS.sample }
      let(:params) { core_params.except(missing_param) }

      context "when a param is missing or invalid" do
        it "is_invalid" do
          expect(input.valid?).to be(false)
        end
        it "contains the right error messages" do
          expect(input.humanized_error_messages).to include(missing_param.to_s)
        end
      end
    end

    describe "#validate_association" do
      let(:params) { core_params.merge(id: 1) }

      context "when the association does not exist" do
        before do
          allow(AbstractRecord).to receive(:exists?).with(id: 1).and_return(false)
        end

        it "is nvalid" do
          expect(input.valid?).to be(false)
        end

        it "contains the right error messages" do
          expect(input.humanized_error_messages).to include("Could not find any 'Abstractrecord' with id: 1")
        end
      end
    end

    describe "#validate_polymorphic_association!" do
      let(:params) { core_params.merge(id: 1, type: PolymorphicAbstractRecord.to_s) }

      context "when the polymorphic association does not exist" do
        before do
          allow(AbstractRecord).to receive(:exists?).with(id: 1).and_return(true)
          allow(PolymorphicAbstractRecord).to receive(:find_by).with(id: 1).and_return(nil)
        end

        it "is invalid" do
          expect(input.valid?).to be(false)
        end

        it "contains the right error messages" do
          expect(input.humanized_error_messages).to include("Could not find any 'Polymorphicabstractrecord' with id: 1")
        end
      end

      context "when the polymorphic association type is invalid" do
        let(:params) { core_params.merge(id: 1, type: "MissingPolymorphicTypeClass") }
        before do
          allow(AbstractRecord).to receive(:exists?).with(id: 1).and_return(true)
        end

        it "is invalid" do
          expect(input.valid?).to be(false)
        end

        it "contains the right error messages" do
          expect(input.humanized_error_messages).to include("Invalid association type: Missingpolymorphictypeclass")
        end
      end
    end
  end
end
