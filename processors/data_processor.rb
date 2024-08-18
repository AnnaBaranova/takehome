require_relative '../helpers/error_helper'
require_relative '../helpers/data_formatter'
require_relative '../helpers/data_validator'
require_relative 'user_processor'
require_relative 'company_processor'


class DataProcessor
  def initialize(companies, users)
    @companies = Helpers::DataValidator.validate_data_structure(companies, 'companies').sort_by { |company| company['id'] }
    @user_processor = UserProcessor.new(users)
    @company_processor = CompanyProcessor.new(@user_processor) # nik: why is this not initialized with companies?
  end

  def process_all_companies
    puts "Processing companies...#{@companies.length}"
    @companies.map do |company|

      puts "Processing company: #{company['id']}"
      @company_processor.process_company_details(company)
      # remove nil entries from the output
    end.compact
  end
end