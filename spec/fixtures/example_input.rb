# frozen_string_literal: true

require "rwc/core/base_input"

class AbstractRecord
  class << self
    def exists?(**args); end
    def find_by(**args); end
  end
end

class PolymorphicAbstractRecord < AbstractRecord
end

class BasicExampleInput < Rwc::Core::BaseInput
  REQUIRED_KEYS = %i[name age id].freeze
  attributes(*REQUIRED_KEYS, :email, :type)

  def validate!
    validate_required_keys!
    validate_association(id, AbstractRecord)
    validate_polymorphic_association!(type || AbstractRecord.to_s, id)
  end
end
