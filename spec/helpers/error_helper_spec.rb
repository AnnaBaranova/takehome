require 'rspec'
require_relative '../../helpers/error_helper'

# Test suite for Helpers::ErrorHelper

RSpec.describe Helpers::ErrorHelper do
  describe '.handle_error' do
    let(:message) { 'An error occurred' }
    let(:exception) { StandardError.new('Something went wrong') }

    context 'when only a message is provided' do
      it 'raises an error with the message' do
        expect { described_class.handle_error(message) }.to raise_error(RuntimeError, message)
      end
    end

    context 'when a message and an exception are provided' do
      it 'raises an error with the message and exception message' do
        expect { described_class.handle_error(message, exception) }.to raise_error(RuntimeError, "#{message} - #{exception.message}")
      end
    end
  end
end