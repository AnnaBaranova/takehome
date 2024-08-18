require_relative 'error_helper'
require_relative '../models/company'
require_relative '../models/user'

module Helpers
  module DataFormatter

    def self.format_company_output(company_id, company_name, users_emailed, users_not_emailed, total_top_ups)
      # format the company output to be written to the output file
      begin
        # validate the company data
        return [] unless company_id

        output = []
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