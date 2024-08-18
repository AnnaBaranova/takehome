require_relative '../helpers/error_helper'
require_relative '../helpers/data_formatter'
require_relative '../helpers/data_validator'
require_relative '../models/user'

# UserProcessor class
# 
# The UserProcessor class is responsible for processing user data for a company.
# 
# Attributes:
# - users [Array<Hash>]: The list of user data.
# 
# Methods:
# - process_users_for_company: Processes the users for a company and formats the output.
# 
#

class UserProcessor
  def initialize(users)
    @users = Helpers::DataValidator.validate_data_structure(users, 'users').sort_by { |user| user['last_name'] }
  end

  # Process the users for a company and format the output
  # @param company_id [Integer] the id of the company
  # @param company_email_status [Boolean] the email status of the company
  # @param top_up_amount [Integer] the top up amount for the company
  # @return [Array<Hash>] the formatted user output
  # @raise [StandardError] if an unexpected error occurs

  def process_users_for_company(company_id, company_email_status, top_up_amount)
    users_emailed = []
    users_not_emailed = []
    total_top_ups = 0

    company_users = @users.select { |user| is_company_user_active?(user, company_id) }
                          .sort_by { |user| user['last_name'] }

    if company_users.empty?
      return users_emailed, users_not_emailed, total_top_ups
    end

    company_users.each do |user|
      begin
        # create a new user object
        user = User.new(user)
  
        previous_balance = user.tokens || 0
        new_balance = update_user_balance(previous_balance, top_up_amount)

        # format the user info
        user_info = user.formatted_user_info(previous_balance, new_balance)

        if user.email_status && company_email_status
          users_emailed << user_info
        else
          users_not_emailed << user_info
        end

        total_top_ups += top_up_amount
      rescue KeyError => e
        Helpers::ErrorHelper.handle_error("Error processing user: #{e.message}", e)
      rescue StandardError => e
        Helpers::ErrorHelper.handle_error("An unexpected error occurred while processing user: #{e.message}", e)
      end
    end

    [users_emailed, users_not_emailed, total_top_ups]
  end

  private

    # Check if the user belongs to the company and is active
    # @param user [Hash] the user data
    # @param company_id [Integer] the id of the company
    # @return [Boolean] true if the user belongs to the company and is active, false otherwise
    def is_company_user_active?(user, company_id)
      user['company_id'] == company_id && user['active_status']
    end

    # Update the user balance
    # @param previous_balance [Integer] the previous balance of the user
    # @param top_up_amount [Integer] the top up amount for the user
    # @return [Integer] the new balance of the user

    def update_user_balance(previous_balance, top_up_amount)
      previous_balance + top_up_amount
    end
end

