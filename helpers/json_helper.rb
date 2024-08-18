require 'json'
require_relative 'file_helper'
require_relative 'error_helper'

module Helpers
  module JsonHelper
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