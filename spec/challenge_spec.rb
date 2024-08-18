require 'rspec'
require_relative '../challenge'
require_relative '../helpers/json_helper'
require_relative '../helpers/file_helper'
require_relative '../processors/data_processor'
require_relative '../helpers/error_helper'

RSpec.describe 'Challenge' do
  before do
    allow(Helpers::JsonHelper).to receive(:load_json).with('users.json').and_return(users)
    allow(Helpers::JsonHelper).to receive(:load_json).with('companies.json').and_return(companies)
    allow(DataProcessor).to receive(:new).with(companies, users).and_return(processor)
    allow(processor).to receive(:process_all_companies).and_return(output)
    allow(Helpers::FileHelper).to receive(:write_data_to_file).with('output.txt', output)
    allow(Helpers::FileHelper).to receive(:write_data_to_file).with('output.txt', [])
    allow(Helpers::ErrorHelper).to receive(:handle_error)
  end

  let(:users) { [{ id: 1, name: 'User1' }] }
  let(:companies) { [{ id: 1, name: 'Company1' }] }
  let(:processor) { instance_double(DataProcessor) }
  let(:output) { [{ id: 1, name: 'Company1', users: [users.first] }] }

  it 'loads users data' do
    process_companies_users_data
    expect(Helpers::JsonHelper).to have_received(:load_json).with('users.json')
  end

  it 'loads companies data' do
    process_companies_users_data
    expect(Helpers::JsonHelper).to have_received(:load_json).with('companies.json')
  end

  it 'creates a DataProcessor instance' do
    process_companies_users_data
    expect(DataProcessor).to have_received(:new).with(companies, users)
  end

  it 'processes the data' do
    process_companies_users_data
    expect(processor).to have_received(:process_all_companies)
  end

  it 'writes the output to a file' do
    process_companies_users_data
    expect(Helpers::FileHelper).to have_received(:write_data_to_file).with('output.txt', output)
  end

  it 'handles errors during processing' do
    allow(processor).to receive(:process_all_companies).and_raise(StandardError.new('error'))
    process_companies_users_data
    expect(Helpers::ErrorHelper).to have_received(:handle_error).with("An unexpected error occurred while processing companies and users data", instance_of(StandardError))
  end

  it 'writes empty output to a file on error' do
    allow(processor).to receive(:process_all_companies).and_raise(StandardError.new('error'))
    process_companies_users_data
    expect(Helpers::FileHelper).to have_received(:write_data_to_file).with('output.txt', [])
  end
end