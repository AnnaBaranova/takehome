require 'rspec'
require_relative '../../helpers/data_formatter'
require_relative '../../helpers/error_helper'

RSpec.describe Helpers::DataFormatter do
  describe '.format_company_output' do
    subject(:output) { described_class.format_company_output(company_id, company_name, users_emailed, users_not_emailed, total_top_ups) }

    let(:company_id) { 1 }
    let(:company_name) { 'Test Company' }
    let(:users_emailed) { [{ name: 'Nichols, Tanya', email: 'tanya.nichols@test.com', previous_balance: 23, new_balance: 40 }] }
    let(:users_not_emailed) { [{ name: 'Rodriquez, Brent', email: 'brent.rodriquez@test.com', previous_balance: 10, new_balance: 20 }] }
    let(:total_top_ups) { 100 }

    context 'with all valid inputs' do
      it 'includes the company id' do
        expect(output).to include("\tCompany Id: 1")
      end

      it 'includes the company name' do
        expect(output).to include("\tCompany Name: Test Company")
      end

      it 'includes the users emailed section' do
        expect(output).to include("\tUsers Emailed:")
      end

      it 'includes the first user emailed' do
        expect(output).to include("\t\tNichols, Tanya, tanya.nichols@test.com")
      end

      it 'includes the previous balance of the first user emailed' do
        expect(output).to include("\t\t\tPrevious Token Balance: 23")
      end

      it 'includes the new balance of the first user emailed' do
        expect(output).to include("\t\t\tNew Token Balance: 40")
      end

      it 'includes the users not emailed section' do
        expect(output).to include("\tUsers Not Emailed:")
      end

      it 'includes the first user not emailed' do
        expect(output).to include("\t\tRodriquez, Brent, brent.rodriquez@test.com")
      end

      it 'includes the previous balance of the first user not emailed' do
        expect(output).to include("\t\t\tPrevious Token Balance: 10")
      end

      it 'includes the new balance of the first user not emailed' do
        expect(output).to include("\t\t\tNew Token Balance: 20")
      end

      it 'includes the total top ups' do
        expect(output).to include("\t\tTotal amount of top ups for Test Company: 100")
      end
    end

    context 'with missing company_name' do
      let(:company_name) { nil }

      it 'formats the company output without company name' do
        expect(output).not_to include("\tCompany Name:")
      end
    end

    context 'with missing users' do
      let(:users_emailed) { [] }
      let(:users_not_emailed) { [] }

      it 'includes the users emailed section' do
        expect(output).to include("\tUsers Emailed:")
      end

      it 'includes the users not emailed section' do
        expect(output).to include("\tUsers Not Emailed:")
      end
    end

    context 'with missing total_top_ups' do
      let(:total_top_ups) { nil }

      it 'formats the company output without total top ups' do
        expect(output).not_to include("\t\tTotal amount of top ups for Test Company:")
      end
    end
  end
end