require 'rspec'
require_relative '../../helpers/error_helper'
require_relative '../../helpers/data_formatter'
require_relative '../../helpers/data_validator'
require_relative '../../models/user'
require_relative '../../processors/user_processor'

RSpec.describe UserProcessor do
  let(:users) do
    [
      { 'id' => 1, 'last_name' => 'Smith', 'first_name' => 'Lucy', 'company_id' => 1, 'active_status' => true, 'email_status' => true, 'tokens' => 30, 'email' => 'h1@test.ca' },
      { 'id' => 2, 'last_name' => 'Johnson', 'first_name' => 'Sara', 'company_id' => 2, 'active_status' => false, 'email_status' => true, 'tokens' => 20, 'email' => 'h2@test.ca' },
    ]
  end
  let(:user_processor) { described_class.new(users) }
  let(:company_id) { 1 }
  let(:company_email_status) { true }
  let(:top_up_amount) { 10 }

  describe '#process_users_for_company' do
    context 'when the company has active users' do
      it 'processes the users and returns the correct name for the user emailed' do
        users_emailed, users_not_emailed, total_top_ups = user_processor.process_users_for_company(company_id, company_email_status, top_up_amount)
        expect(users_emailed.first[:name]).to eq('Smith, Lucy')
      end

      it 'processes the users and returns the correct number of users emailed' do
        users_emailed, users_not_emailed, total_top_ups = user_processor.process_users_for_company(company_id, company_email_status, top_up_amount)
        expect(users_emailed.size).to eq(1)
      end
    end

    context 'when the company has no active users' do
      let(:company_id) { 3 }

      it 'returns empty arrays for users_emailed' do
        users_emailed, users_not_emailed, total_top_ups = user_processor.process_users_for_company(company_id, company_email_status, top_up_amount)

        expect(users_emailed).to be_empty
      end

      it 'returns empty arrays for users_not_emailed' do
        users_emailed, users_not_emailed, total_top_ups = user_processor.process_users_for_company(company_id, company_email_status, top_up_amount)
        expect(users_not_emailed).to be_empty
      end
    end

    context 'when a KeyError occurs' do
      before do
        allow(User).to receive(:new).and_raise(KeyError, 'key not found')
        allow(Helpers::ErrorHelper).to receive(:handle_error).once
      end

      it 'handles the KeyError' do
        user_processor.process_users_for_company(company_id, company_email_status, top_up_amount)
        expect(Helpers::ErrorHelper).to have_received(:handle_error).with('Error processing user: key not found', instance_of(KeyError)).once
      end
    end

    context 'when a StandardError occurs' do
      before do
        allow(User).to receive(:new).and_raise(StandardError, 'unexpected error')
        allow(Helpers::ErrorHelper).to receive(:handle_error).once
      end

      it 'handles the StandardError' do
        user_processor.process_users_for_company(company_id, company_email_status, top_up_amount)
        expect(Helpers::ErrorHelper).to have_received(:handle_error).with('An unexpected error occurred while processing user: unexpected error', instance_of(StandardError)).once
      end
    end
  end
end