require 'pathname'
require_relative 'error_helper'

# Helper module for operations on files like reading and writing
#
# This module provides utility methods to read from and write to files.
# It includes error handling for common file-related issues such as
# file not found, IO errors, and other unexpected errors.
#
# Methods:
# - read_file(file_path, base_dir): Read the content of a file.
# - write_data_to_file(file_path, data, base_dir): Write data to a file.

module Helpers
  module FileHelper
    # Read the content of a file
    # @param file_path [String] the path to the file
    # @param base_dir [String] the base directory to use for the file path
    # @return [String] the content of the file
    # @raise [StandardError] if the file is not found, an IO error occurs, or an unexpected error occurs

    def self.read_file(file_path, base_dir = Dir.pwd)
      begin
        # convert the base directory to a Pathname object
        base_dir = Pathname.new(base_dir)
        absolute_path = Pathname.new(file_path).expand_path(base_dir)

        # validate the file path
        validate_file_path(absolute_path)

        # read the file content
        absolute_path.read

      rescue Errno::ENOENT
        ErrorHelper.handle_error("File not found in the specified path #{file_path}")
      rescue IOError => e
        ErrorHelper.handle_error("An error occurred while reading the file #{file_path}", e)
      rescue StandardError => e
        ErrorHelper.handle_error("An unexpected error occurred while reading the file #{file_path}", e)
      end
    end


    # Write data to a file
    # @param file_path [String] the path to the file
    # @param data [Array<String>] the data to write to the file
    # @param base_dir [String] the base directory to use for the file path
    # @raise [StandardError] if the file is not found, an IO error occurs, or an unexpected error occurs


    def self.write_data_to_file(file_path, data, base_dir = Dir.pwd)
      begin

        # convert the base directory to a Pathname object
        base_dir = Pathname.new(base_dir)

        # expand the file path to an absolute path
        absolute_path = Pathname.new(file_path).expand_path(base_dir)

        # write the data to the file
        File.open(absolute_path, 'w') do |file|
          data.each { |line| file.puts(line) }
        end

      rescue Errno::ENOENT
        ErrorHelper.handle_error("File not found in the specified path #{file_path}")
      rescue IOError => e
        ErrorHelper.handle_error("An error occurred while writing to the file #{file_path}", e)
      rescue StandardError => e
        ErrorHelper.handle_error("An unexpected error occurred while writing to the file #{file_path}", e)
      end
    end

    private

    # Validate the file path
    # @param file_path [Pathname] the file path to validate
    # @raise [StandardError] if the file path is invalid

    def self.validate_file_path(file_path)
      raise "Invalid file path: #{file_path}" unless file_path.exist? && file_path.file?
    end
  end
end