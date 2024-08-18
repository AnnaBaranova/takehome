require 'rspec'
require_relative '../../helpers/error_helper'
require_relative '../../helpers/data_formatter'
require_relative '../../helpers/data_validator'
require_relative '../../processors/user_processor'
require_relative '../../processors/company_processor'
require_relative '../../processors/data_processor'

RSpec.describe DataProcessor do
  let(:companies) do
    [
      { 'id' => 1, 'name' => 'Company A' },
      { 'id' => 2, 'name' => 'Company B' }
    ]
  end

  let(:users) do
    [
      { 'id' => 1, 'last_name' => 'Smith', 'first_name' => 'Lucy', 'company_id' => 1, 'active_status' => true, 'email_status' => true, 'tokens' => 30, 'email' => 'h1@test.ca' },
      { 'id' => 2, 'last_name' => 'Johnson', 'first_name' => 'Sara', 'company_id' => 2, 'active_status' => false, 'email_status' => true, 'tokens' => 20, 'email' => 'h2@test.ca' }
    ]
  end

  let(:user_processor) { instance_double(UserProcessor) }
  let(:company_processor) { instance_double(CompanyProcessor) }
  let(:data_processor) { described_class.new(companies, users) }

  before do
    allow(UserProcessor).to receive(:new).and_return(user_processor)
    allow(CompanyProcessor).to receive(:new).with(user_processor).and_return(company_processor)
    allow(Helpers::DataValidator).to receive(:validate_data_structure).with(companies, 'companies').and_return(companies)
  end

  describe '#process_all_companies' do
    before do
      allow(company_processor).to receive(:process_company_details).with(companies[0]).and_return('Processed Company A')
      allow(company_processor).to receive(:process_company_details).with(companies[1]).and_return('Processed Company B')
    end

    it 'processes the first company' do
      data_processor.process_all_companies
      expect(company_processor).to have_received(:process_company_details).with(companies[0])
    end

    it 'processes the second company' do
      data_processor.process_all_companies
      expect(company_processor).to have_received(:process_company_details).with(companies[1])
    end

    it 'returns the results' do
      result = data_processor.process_all_companies
      expect(result).to eq(['Processed Company A', 'Processed Company B'])
    end

    context 'when there are nil entries' do
      before do
        allow(company_processor).to receive(:process_company_details).with(companies[1]).and_return(nil)
      end

      it 'removes nil entries from the output' do
        result = data_processor.process_all_companies
        expect(result).to eq(['Processed Company A'])
      end

      it 'processes the first company' do
        data_processor.process_all_companies
        expect(company_processor).to have_received(:process_company_details).with(companies[0])
      end

      it 'processes the second company' do
        data_processor.process_all_companies
        expect(company_processor).to have_received(:process_company_details).with(companies[1])
      end
    end
  end
end