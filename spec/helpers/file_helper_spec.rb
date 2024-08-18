require 'rspec'
require 'pathname'
require_relative '../../helpers/file_helper'
require_relative '../../helpers/error_helper'

RSpec.describe Helpers::FileHelper do
  describe '.read_file' do
    let(:valid_file_path) { 'spec/fixtures/valid_file.txt' }
    let(:invalid_file_path) { 'spec/fixtures/non_existent_file.txt' }
    let(:base_dir) { Dir.pwd }

    before do
      File.write(valid_file_path, "This is a test file.") unless File.exist?(valid_file_path)
    end

    after do
      File.delete(valid_file_path) if File.exist?(valid_file_path)
    end

    context 'when the file exists' do
      it 'reads the file content' do
        content = described_class.read_file(valid_file_path, base_dir)
        expect(content).to eq("This is a test file.")
      end
    end

    context 'when the file does not exist' do
      it 'raises a file not found error' do
        expect { described_class.read_file(invalid_file_path, base_dir) }.to raise_error(RuntimeError, "An unexpected error occurred while reading the file #{invalid_file_path} - Invalid file path: #{File.join(base_dir, invalid_file_path)}")
      end
    end
  end

  describe '.write_data_to_file' do
    let(:valid_file_path) { 'spec/fixtures/output_file.txt' }
    let(:invalid_file_path) { 'spec/fixtures/non_existent_directory/output_file.txt' }
    let(:base_dir) { Dir.pwd }
    let(:output) { ["Line 1", "Line 2", "Line 3"] }

    after do
      File.delete(valid_file_path) if File.exist?(valid_file_path)
    end

    context 'when the file path is valid' do
      it 'writes the output to the file' do
        described_class.write_data_to_file(valid_file_path, output, base_dir)
        content = File.read(valid_file_path)
        expect(content).to eq("Line 1\nLine 2\nLine 3\n")
      end
    end

    context 'when the file path is invalid' do
      it 'raises a file not found error' do
        expect { described_class.write_data_to_file(invalid_file_path, output, base_dir) }.to raise_error(RuntimeError, "File not found in the specified path #{invalid_file_path}")
      end
    end
  end
end