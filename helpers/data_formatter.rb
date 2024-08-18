require_relative 'error_helper'
require_relative '../models/company'
require_relative '../models/user'

# A module that formats the data to be written to the output file.
#
# This module provides utility methods to format company and user data
# for output. It includes error handling for unexpected issues during
# the formatting process.
#
# Methods:
# - format_company_output(company_id, company_name, users_emailed, users_not_emailed, total_top_ups): Formats the company data.
# - format_user_output(user): Formats the user data.

module Helpers
  module DataFormatter

    # Format the company output to be written to the output file
    # @param company_id [Integer] the id of the company
    # @param company_name [String] the name of the company
    # @param users_emailed [Array<Hash>] the users who were emailed
    # @param users_not_emailed [Array<Hash>] the users who were not emailed
    # @param total_top_ups [Integer] the total amount of top ups for the company
    # @return [Array<String>] the formatted company output
    # @raise [StandardError] if an unexpected error occurs

    def self.format_company_output(company_id, company_name, users_emailed, users_not_emailed, total_top_ups)
      # format the company output to be written to the output file
      begin
        # validate the company data
        return [] unless company_id

        output = []
        output << ""
        output << "\tCompany Id: #{company_id}"
        output << "\tCompany Name: #{company_name}" if company_name

        output << "\tUsers Emailed:"
        users_emailed.each { |user| output.concat(format_user_output(user)) } if users_emailed && !users_emailed.empty?


        output << "\tUsers Not Emailed:"
        users_not_emailed.each { |user| output.concat(format_user_output(user)) } if users_not_emailed && !users_not_emailed.empty?


        output << "\t\tTotal amount of top ups for #{company_name}: #{total_top_ups}" if company_name && !total_top_ups.nil?
        output << ""
        output

      rescue StandardError => e
        ErrorHelper.handle_error("An unexpected error occurred while formatting company output", e)
      end
    end


    # Format the user output to be written to the output file
    # @param user [Hash] the user data
    # @return [Array<String>] the formatted user output
    # @raise [StandardError] if an unexpected error occurs

    def self.format_user_output(user)
      # format the user output to be written to the output file
      begin
        # validate the user data
        return [] if user.nil?
        
        [
          "\t\t#{user[:name]}, #{user[:email]}",
          "\t\t\tPrevious Token Balance: #{user[:previous_balance]}",
          "\t\t\tNew Token Balance: #{user[:new_balance]}"
        ]

      rescue StandardError => e
        ErrorHelper.handle_error("An unexpected error occurred while formatting user output", e)
      end
    end
  end
end