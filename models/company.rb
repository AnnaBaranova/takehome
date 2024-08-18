require_relative '../helpers/error_helper'

class Company
  attr_reader :id, :name, :email_status, :top_up

  def initialize(attributes = {})
    # validate the company data
    validate_company_data(attributes)
    #convert the hash keys to symbols and assign to instance variables
    company = attributes.transform_keys(&:to_sym)

    # nik: are these default values?
    @id = company[:id]
    @name = company[:name] || 'unknown'
    @email_status = company[:email_status] || false
    @top_up = company[:top_up] || 0
  end

  private

    def validate_company_data(company)
      # check if company is nil
      Helpers::ErrorHelper.handle_error("Invalid company data: expected a hash") if company.nil? || !company.is_a?(Hash)

      # required keys
      required_keys = %w[id]

      # check for missing keys
      missing_keys = required_keys.select { |key| !company.key?(key) }
      unless missing_keys.empty?
        Helpers::ErrorHelper.handle_error("Company missing #{missing_keys.join(', ')}")
      end
    end
end