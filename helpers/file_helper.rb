require 'pathname'
require_relative 'error_helper'

module Helpers
  module FileHelper
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

    def self.validate_file_path(file_path)
      raise "Invalid file path: #{file_path}" unless file_path.exist? && file_path.file?
    end
  end
end