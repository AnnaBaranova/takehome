require 'rspec'
require_relative '../../helpers/data_validator'
require_relative '../../helpers/error_helper'

# Test suite for Helpers::DataValidator

RSpec.describe Helpers::DataValidator do
  describe '.validate_data_structure' do
    let(:valid_data) { [{ key: 'value' }, { key: 'value' }] }
    let(:invalid_data_nil) { nil }
    let(:invalid_data_not_array) { 'not an array' }
    let(:invalid_data_entry_not_hash) { ['not a hash'] }

    context 'with valid data structure' do
      it 'returns the data' do
        expect(described_class.validate_data_structure(valid_data, 'test')).to eq(valid_data)
      end
    end

    context 'with nil data' do
      it 'raises an error' do
        expect { described_class.validate_data_structure(invalid_data_nil, 'test') }.to raise_error(RuntimeError, 'Invalid test data: expected an array')
      end
    end

    context 'with data not being an array' do
      it 'raises an error' do
        expect { described_class.validate_data_structure(invalid_data_not_array, 'test') }.to raise_error(RuntimeError, 'Invalid test data: expected an array')
      end
    end

    context 'with entries in the array not being hashes' do
      it 'raises an error' do
        expect { described_class.validate_data_structure(invalid_data_entry_not_hash, 'test') }.to raise_error(RuntimeError, 'Invalid test data: each entry must be a hash')
      end
    end
  end
end