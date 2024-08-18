require_relative 'helpers/json_helper'
require_relative 'helpers/file_helper'
require_relative 'processors/data_processor'
require_relative 'helpers/error_helper'

# Constants
USERS_FILE = 'users.json'
COMPANIES_FILE = 'companies.json'
OUTPUT_FILE = 'output.txt'

# Process the companies and users data - main method.
# This method loads the companies and users data from JSON files,
# processes the data, and writes the output to a file.
# It handles any unexpected errors that occur during the process.
#
# @return [void]
#


def process_companies_users_data
  users = []
  companies = []

  puts "Start the process".upcase

  # load data from JSON files
  begin
    users = Helpers::JsonHelper.load_json(USERS_FILE)
    puts "Users data loaded successfully with #{users.length} users"
  rescue StandardError => e
    Helpers::ErrorHelper.handle_error("An unexpected error occurred while loading users data from #{USERS_FILE}", e)
  end

  begin
    companies = Helpers::JsonHelper.load_json(COMPANIES_FILE)
    puts "Companies data loaded successfully with #{companies.length} companies"
  rescue StandardError => e
    Helpers::ErrorHelper.handle_error("An unexpected error occurred while loading companies data from #{COMPANIES_FILE}", e)
  end

  # create a new DataProcessor instance
  processor = DataProcessor.new(companies, users)

  # process the data
  output = []
  begin
    puts "Processing data..."
    output = processor.process_all_companies
    puts "Data processed successfully. #{output.length} companies are in the output"

  rescue StandardError => e
    Helpers::ErrorHelper.handle_error("An unexpected error occurred while processing companies and users data", e)
  end

  # write the output to a file
  begin
    Helpers::FileHelper.write_data_to_file(OUTPUT_FILE, output)
    puts "Processing complete. Output written to output.txt"
  rescue StandardError => e
    Helpers::ErrorHelper.handle_error("An unexpected error occurred while writing the output to #{OUTPUT_FILE}", e)
  end

  puts "Process completed".upcase
end

# Call the main method to process the companies and users data
process_companies_users_data