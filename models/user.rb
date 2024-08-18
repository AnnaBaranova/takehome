require_relative '../helpers/error_helper'

# User class

# The User class is responsible for creating user objects
# and formatting user data
#
# Attributes:
# - id [Integer]: The ID of the user.
# - first_name [String]: The first name of the user.
# - last_name [String]: The last name of the user.
# - email [String]: The email of the user.
# - company_id [Integer]: The ID of the company the user belongs to.
# - email_status [Boolean]: The email status of the user.
# - active_status [Boolean]: The active status of the user.
# - tokens [Integer]: The tokens balance of the user.
#
# Methods:
# - initialize: Initializes the user with the provided attributes and default values.
# - formatted_user_info: Formats the user data for output.
# - validate_user_data: Validates the user data to ensure it is a hash and contains the required keys.

class User
  attr_reader :id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens, :full_name, :previous_balance, :new_balance

  def initialize(attributes = {})
    # validate the user data
    validate_user_data(attributes)

    #convert the hash keys to symbols and assign to instance variables
    user = attributes.transform_keys(&:to_sym)

    @id = user[:id]
    @first_name = user[:first_name] || 'unknown'
    @last_name = user[:last_name] || 'unknown'
    @full_name = full_name
    @email = user[:email] || 'unknown'
    @company_id = user[:company_id] || 'unknown'
    @email_status = user[:email_status] || false
    @active_status = user[:active_status] || false
    @tokens = user[:tokens] || 0
  end

  # Format the user data for output
  # @param previous_balance [Integer] the previous balance of the user
  # @param new_balance [Integer] the new balance of the user
  # @return [Hash] the formatted user data

  def formatted_user_info(previous_balance, new_balance)
    {
      name: @full_name,
      email: @email,
      previous_balance: previous_balance,
      new_balance: new_balance
    }
  end

  private

  # Validate the user data to ensure it is a hash and contains the required keys
  # @param user [Hash] the user data to validate
  # @raise [StandardError] if the user data is invalid

  def validate_user_data(user)
    Helpers::ErrorHelper.handle_error("Invalid user data: expected a hash") if user.nil? || !user.is_a?(Hash)

    required_keys = %w[id]

    missing_keys = required_keys.select { |key| !user.key?(key) }
    unless missing_keys.empty?
      Helpers::ErrorHelper.handle_error("User missing #{missing_keys.join(', ')}")
    end
  end

  def full_name
    "#{last_name || 'unknown'}, #{first_name || 'unknown'}"
  end
end