require_relative '../helpers/error_helper'
require_relative '../helpers/data_formatter'
require_relative '../helpers/data_validator'
require_relative 'user_processor'
require_relative 'company_processor'

# DataProcessor class
#
# The DataProcessor class is responsible for processing ALL companies data along with the users that belong to the companies.
#
# Attributes:
# - companies [Array<Hash>]: The list of company data.
# - users [Array<Hash>]: The list of user data.
#
# Methods:
# - process_all_companies: Processes all the companies and formats the output.
#

class DataProcessor
  def initialize(companies, users)
    @companies = Helpers::DataValidator.validate_data_structure(companies, 'companies').sort_by { |company| company['id'] }
    @user_processor = UserProcessor.new(users)
    @company_processor = CompanyProcessor.new(@user_processor)
  end

  # Process all the companies and format the output
  # @return [Array<String>] the formatted output
  # @raise [StandardError] if an unexpected error occurs
  def process_all_companies
    puts "Processing companies...#{@companies.length}"
    @companies.map do |company|
      puts "Processing company: #{company['id']}"
      @company_processor.process_company_details(company)
      # remove nil entries from the output
    end.compact
  rescue StandardError => e
    Helpers::ErrorHelper.handle_error('An unexpected error occurred while processing companies data', e)
  end
end