# frozen_string_literal: true

module Rwc
  module Concerns
      # Provides validation methods for input classes.
module Validation
  # Checks if the input is valid by running validations.
  #
  # @return [Boolean] True if valid; otherwise, false.
  def valid?
    validate!
    errors.empty?
  end

  # Validates the input. Must be implemented by including class.
  #
  # @raise [NotImplementedError] If not implemented.
  def validate!
    raise NotImplementedError
  end

  private

  # Pipes an error into the errors array.
  #
  # @param [StandardError] error The error to be added.
  def pipe_error(error)
    @errors << error
  end

  # Validates the presence of a given key in the input.
  #
  # @param [Symbol] key The key to validate.
  def validate_presence_of(key)
    pipe_error(BaseInput::InputValidationError.new("#{key} is missing")) if input.send(key).blank?
  end

  # Creates an error with a specified message.
  #
  # @param [String] message The error message.
  # @return [BaseInput::InputValidationError] The generated error.
  def error(message)
    BaseInput::InputValidationError.new(message)
  end

  # Validates polymorphic associations based on type and ID.
  #
  # @param [String] type The type of the association.
  # @param [Integer] id The ID of the associated record.
  # @param [Boolean] conditional Optional. If true, skips validation if id is blank.
  def validate_polymorphic_association!(type, id, conditional: false)
    within_error_context do
      return if conditional && id.blank?

      pipe_error(relation_not_found_error(type, id)) unless type.constantize.find_by(id:)
    rescue NameError
      pipe_error(invalid_type_error(type))
    end
  end

  # Validates an association by checking its existence.
  #
  # @param [Integer] id The ID of the associated record.
  # @param [Class] klass The class of the association.
  # @param [Boolean] conditional Optional. If true, skips validation if id is blank.
  def validate_association!(id, klass, conditional: false)
    within_error_context do
      return if conditional && id.blank?

      pipe_error(relation_not_found_error(klass.to_s, id)) unless klass.exists?(id:)
    end
  end

  # Validates the existence of a record associated with the input.
  #
  # @raise [BaseInput::InputValidationError] If validation fails.
  def validate_record!
    within_error_context do
      validate_association!(id, self.class.target) if id
    end
  end

  # Validates required keys for the input.
  #
  # @raise [BaseInput::InputValidationError] If any required keys are missing.
  def validate_required_keys!
    within_error_context do
      self.class::REQUIRED_KEYS.each do |key|
        validate_presence_of(key)
      end
    end
  end

  # Validates the ownership of a record by a user.
  #
  # @param [ActiveRecord::Base] record The record to check ownership against.
  # @param [Integer] user_id The ID of the user to validate ownership.
  def validate_ownership!(record, user_id)
    within_error_context do
      pipe_error(restricted_access_error) unless owner_for(record)&.id == user_id
    end
  end

  # Executes a block if there are no errors.
  #
  # @yield The block to execute.
  def within_error_context(&block)
    block.call if errors.empty?
  end

  # Collates errors from specified keys into the errors array.
  #
  # @param [Array<Symbol>] keys The keys to collate errors for.
  def collate_errors_for(*keys)
    keys.each do |key|
      within_error_context do
        target = send(key)
        next @errors += target.errors if target.respond_to?(:valid?) && !target.valid?

        target.each do |node|
          within_error_context do
            @errors += node.errors unless node.valid?
          end
        end
      end
    end
  end

  # Generates an error for an invalid association type.
  #
  # @param [String] type The invalid type.
  # @return [BaseInput::InputValidationError] The generated error.
  def invalid_type_error(type)
    BaseInput::InputValidationError.new("Invalid association type: #{type.capitalize}")
  end

  # Generates an error when a relation cannot be found.
  #
  # @param [String] type The type of the relation.
  # @param [Integer] id The ID of the relation.
  # @return [BaseInput::InputValidationError] The generated error.
  def relation_not_found_error(type, id)
    BaseInput::InputValidationError.new("Could not find any '#{type.capitalize}' with id: #{id}")
  end

  # Generates an error for restricted access.
  #
  # @return [BaseInput::InputValidationError] The generated error.
  def restricted_access_error
    BaseInput::InputValidationError.new('Unauthorized access')
  end

  # Generates an error for a missing field.
  #
  # @param [Symbol] field The missing field.
  # @return [BaseInput::InputValidationError] The generated error.
  def missing_field_error(field)
    BaseInput::InputValidationError.new("#{field} is missing")
  end
  end
    end
  end

