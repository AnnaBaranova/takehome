require_relative '../helpers/error_helper'
require_relative '../helpers/data_formatter'
require_relative '../helpers/data_validator'
require_relative '../models/user'

class UserProcessor
  def initialize(users)
    @users = Helpers::DataValidator.validate_data_structure(users, 'users').sort_by { |user| user['last_name'] }
  end

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
    def is_company_user_active?(user, company_id)
      user['company_id'] == company_id && user['active_status']
    end

    def update_user_balance(previous_balance, top_up_amount)
      previous_balance + top_up_amount
    end
end

