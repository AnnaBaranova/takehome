require 'rspec'
require_relative '../../helpers/error_helper'
require_relative '../../helpers/data_formatter'
require_relative '../../helpers/data_validator'
require_relative '../../models/company'
require_relative '../../processors/company_processor'

RSpec.describe CompanyProcessor do
  let(:user_processor) { instance_double(UserProcessor) }
  let(:company_processor) { described_class.new(user_processor) }
  let(:company_data) { { id: 1, name: 'Test Company', email_status: 'active', top_up: 100 } }
  let(:company) { instance_double(Company, company_data) }
  let(:users_data) do
    {
      users_emailed: ['user1@example.com'],
      users_not_emailed: ['user2@example.com'],
      total_top_ups: 200
    }
  end

  before do
    allow(Company).to receive(:new).and_return(company)
  end

  describe '#process_company_details' do
    context 'when the company has users' do
      before do
        allow(user_processor).to receive(:process_users_for_company).and_return([users_data[:users_emailed], users_data[:users_not_emailed], users_data[:total_top_ups]])
        allow(Helpers::DataFormatter).to receive(:format_company_output)
      end

      it 'processes the company details' do
        company_processor.process_company_details(company_data)
        expect(user_processor).to have_received(:process_users_for_company).with(company_data[:id], company_data[:email_status], company_data[:top_up])
      end

      it 'formats the output' do
        company_processor.process_company_details(company_data)
        expect(Helpers::DataFormatter).to have_received(:format_company_output).with(company_data[:id], company_data[:name], users_data[:users_emailed], users_data[:users_not_emailed], users_data[:total_top_ups])
      end
    end

    context 'when the company has no users' do
      before do
        allow(user_processor).to receive(:process_users_for_company).and_return([[], [], 0])
      end

      it 'returns nil' do
        result = company_processor.process_company_details(company_data)
        expect(result).to be_nil
      end
    end

    context 'when a KeyError occurs' do
      before do
        allow(Company).to receive(:new).and_raise(KeyError, 'key not found')
        allow(Helpers::ErrorHelper).to receive(:handle_error)
      end

      it 'handles the KeyError' do
        company_processor.process_company_details(company_data)
        expect(Helpers::ErrorHelper).to have_received(:handle_error).with('Error processing company data: key not found', instance_of(KeyError))
      end
    end

    context 'when a StandardError occurs' do
      before do
        allow(Company).to receive(:new).and_raise(StandardError, 'unexpected error')
        allow(Helpers::ErrorHelper).to receive(:handle_error)
      end

      it 'handles the StandardError' do
        company_processor.process_company_details(company_data)
        expect(Helpers::ErrorHelper).to have_received(:handle_error).with('An unexpected error occurred: unexpected error', instance_of(StandardError))
      end
    end
  end
end