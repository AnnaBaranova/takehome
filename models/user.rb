require_relative '../helpers/error_helper'

class User
  attr_reader :id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens, :full_name, :previous_balance, :new_balance

  def initialize(attributes = {})
    # validate the user data
    validate_user_data(attributes)

    #convert the hash keys to symbols and assign to instance variables
    user = attributes.transform_keys(&:to_sym)

    # nik: default values?
    @id = user[:id]
    @first_name = user[:first_name]
    @last_name = user[:last_name]
    @full_name = full_name
    @email = user[:email]
    @company_id = user[:company_id]
    @email_status = user[:email_status]
    @active_status = user[:active_status]
    @tokens = user[:tokens]
  end

  def formatted_user_info(previous_balance, new_balance)
    {
      name: @full_name,
      email: @email,
      previous_balance: previous_balance,
      new_balance: new_balance
    }
  end

  private

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