require_relative 'error_helper'

module Helpers
  module DataValidator

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