require_relative '../helpers/error_helper'

# Company class
#
# This class represents a company and its attributes with methods to validate the company data
#
# Attributes:
# - id [Integer]: The ID of the company.
# - name [String]: The name of the company.
# - email_status [Boolean]: The email status of the company.
# - top_up [Integer]: The top-up amount for the company.
#
# Methods:
# - initialize: Initializes the company with the provided attributes and default values.
# - validate_company_data: Validates the company data to ensure it is a hash and contains the required keys.
#

class Company
  attr_reader :id, :name, :email_status, :top_up

  def initialize(attributes = {})
    # validate the company data
    validate_company_data(attributes)
    #convert the hash keys to symbols and assign to instance variables
    company = attributes.transform_keys(&:to_sym)

    @id = company[:id]
    @name = company[:name] || 'unknown'
    @email_status = company[:email_status] || false
    @top_up = company[:top_up] || 0
  end

  private

    # Validate the company data to ensure it is a hash and contains the required keys
    # @param company [Hash] the company data to validate
    # @raise [StandardError] if the company data is invalid

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