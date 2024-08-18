require 'rspec'
require_relative '../../models/company'
require_relative '../../helpers/error_helper'

RSpec.describe Company, type: :model do
  describe '#initialize' do
    context 'with valid attributes' do
      let(:attributes) { { "id" => 1, "name" => 'Test Company', "email_status" => true, "top_up" => 100 } }
      let(:company) { described_class.new(attributes) }

      it 'initializes the company with the correct id' do
        expect(company.id).to eq(1)
      end

      it 'initializes the company with the correct name' do
        expect(company.name).to eq('Test Company')
      end

      it 'initializes the company with the correct email status' do
        expect(company.email_status).to be(true)
      end

      it 'initializes the company with the correct top up' do
        expect(company.top_up).to eq(100)
      end
    end

    context 'with missing optional attributes' do
      let(:attributes) { { "id" => 1 } }
      let(:company) { described_class.new(attributes) }

      it 'initializes the company with default name' do
        expect(company.name).to eq('unknown')
      end

      it 'initializes the company with default email status' do
        expect(company.email_status).to be(false)
      end

      it 'initializes the company with default top up' do
        expect(company.top_up).to eq(0)
      end
    end

    context 'with missing required attributes' do
      it 'raises an error when id is missing' do
        expect { described_class.new({}) }.to raise_error(RuntimeError, 'Company missing id')
      end

      it 'raises an error when attributes are nil' do
        expect { described_class.new(nil) }.to raise_error(RuntimeError, 'Invalid company data: expected a hash')
      end

      it 'raises an error when attributes are not a hash' do
        expect { described_class.new('invalid') }.to raise_error(RuntimeError, 'Invalid company data: expected a hash')
      end
    end
  end
end