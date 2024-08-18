require_relative 'error_helper'

# A module that validates the structure of the data.

# This module provides utility methods to validate the structure of data
# It includes error handling for common data-related issues such as
# invalid data types, missing data, and other unexpected errors.
#
# Methods:
# - validate_data_structure(data, data_type, expected_type: Array, expected_entry_type: Hash): Validates the structure of the data.

module Helpers
  module DataValidator

    # Validate the structure of the data
    # @param data [Array<Hash>] the data to validate
    # @param data_type [String] the type of data being validated
    # @param expected_type [Array] the expected type of the data
    # @param expected_entry_type [Hash] the expected type of each entry in the data
    # @return [Array<Hash>] the validated data
    # @raise [StandardError] if the data is nil, not an array, or if any entry is not a hash

    def self.validate_data_structure(data, data_type, expected_type: Array, expected_entry_type: Hash)
      # check if data is nil
      ErrorHelper.handle_error("Invalid #{data_type} data: expected an array") if data.nil?
      # check if data is an array
      ErrorHelper.handle_error("Invalid #{data_type} data: expected an array") unless data.is_a?(expected_type)
      
      # check if each entry in the array is a hash
      data.each do |entry|
        ErrorHelper.handle_error("Invalid #{data_type} data: each entry must be a hash") unless entry.is_a?(expected_entry_type)
      end

      data
    end
  end
end