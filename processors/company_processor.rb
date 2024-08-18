require_relative '../helpers/error_helper'
require_relative '../helpers/data_formatter'
require_relative '../helpers/data_validator'
require_relative '../models/company'

# CompanyProcessor class
# 
# The CompanyProcessor class is responsible for processing company data along with the users that belong to the company.
# 
# Attributes:
# - user_processor [UserProcessor]: The UserProcessor object used to process user data.
# 
# Methods:
# - process_company_details: Processes the company data and formats the output.
# 
#

class CompanyProcessor
  def initialize(user_processor)
    @user_processor = user_processor
  end

  # Process the company data and format the output
  # @param company [Hash] the company data
  # @return [Array<String>] the formatted company output
  # @raise [StandardError] if an unexpected error occurs

  def process_company_details(company)
    begin
      # Instantiate the Company object
      company = Company.new(company)

      # get and format company data
      company_id = company.id
      company_name = company.name
      company_email_status = company.email_status
      top_up_amount = company.top_up

      # process users for the company
      users_emailed, users_not_emailed, total_top_ups = @user_processor.process_users_for_company(company_id, company_email_status, top_up_amount)

      # return nil if no users are found for the company
      if users_emailed.empty? && users_not_emailed.empty?
        return nil
      end

      # format the output
      Helpers::DataFormatter.format_company_output(company_id, company_name, users_emailed, users_not_emailed, total_top_ups)

    rescue KeyError => e
      Helpers::ErrorHelper.handle_error("Error processing company data: #{e.message}", e)
    rescue StandardError => e
      Helpers::ErrorHelper.handle_error("An unexpected error occurred: #{e.message}", e)
    end
  end
end