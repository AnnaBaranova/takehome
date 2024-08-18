require 'rspec'
require 'json'
require_relative '../../helpers/json_helper'
require_relative '../../helpers/file_helper'
require_relative '../../helpers/error_helper'

RSpec.describe Helpers::JsonHelper do
  let(:base_dir) { Dir.pwd }

  before do
    File.write('spec/fixtures/valid_json_file.json', { "key" => "value" }.to_json) unless File.exist?('spec/fixtures/valid_json_file.json')
    File.write('spec/fixtures/invalid_json_file.json', "invalid json content") unless File.exist?('spec/fixtures/invalid_json_file.json')
  end

  after do
    File.delete('spec/fixtures/valid_json_file.json') if File.exist?('spec/fixtures/valid_json_file.json')
    File.delete('spec/fixtures/invalid_json_file.json') if File.exist?('spec/fixtures/invalid_json_file.json')
  end

  describe '.load_json' do
    context 'when the JSON file is valid' do
      let(:valid_json_file_path) { 'spec/fixtures/valid_json_file.json' }
      let(:valid_json_content) { { "key" => "value" }.to_json }

      it 'loads and parses the JSON content' do
        result = described_class.load_json(valid_json_file_path, base_dir)
        expect(result).to eq(JSON.parse(valid_json_content))
      end
    end

    context 'when the JSON file content is invalid' do
      let(:invalid_json_file_path) { 'spec/fixtures/invalid_json_file.json' }

      it 'raises a JSON::ParserError' do
        expect { described_class.load_json(invalid_json_file_path, base_dir) }.to raise_error(RuntimeError, "Invalid JSON content in file: #{invalid_json_file_path}")
      end
    end

    context 'when the file does not exist' do
      let(:non_existent_file_path) { 'spec/fixtures/non_existent_file.json' }

      it 'raises a file not found error' do
        expect { described_class.load_json(non_existent_file_path, base_dir) }.to raise_error(RuntimeError, "An unexpected error occurred while loading JSON - An unexpected error occurred while reading the file #{non_existent_file_path} - Invalid file path: #{File.join(base_dir, non_existent_file_path)}")
      end
    end
  end
end