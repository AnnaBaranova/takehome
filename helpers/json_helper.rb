require 'json'
require_relative 'file_helper'
require_relative 'error_helper'

# Helper module for JSON operations
#
# This module provides utility methods to load JSON content from a file.
# It includes error handling for common JSON-related issues such as
# invalid JSON content or file not found.
#
# Methods:
# - load_json(file_path, base_dir): Load JSON content from a file.

module Helpers
  module JsonHelper
    # Load JSON content from a file
    # @param file_path [String] the path to the JSON file
    # @param base_dir [String] the base directory to use for the file path
    # @return [Hash] the parsed JSON content
    # @raise [StandardError] if the JSON content is invalid or the file is not found

    def self.load_json(file_path, base_dir = Dir.pwd)
      begin

        # read the JSON content from the file
        json_content = FileHelper.read_file(file_path, base_dir)

        # parse the JSON content
        JSON.parse(json_content)

      rescue JSON::ParserError
        raise "Invalid JSON content in file: #{file_path}"
      rescue Errno::ENOENT
        ErrorHelper.handle_error("File not found in the specified path #{file_path}")
      rescue StandardError => e
        ErrorHelper.handle_error("An unexpected error occurred while loading JSON", e)
      end
    end
  end
end