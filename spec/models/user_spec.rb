require 'rspec'
require_relative '../../models/user'
require_relative '../../helpers/error_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) do
    {
      "id" => 1,
      "first_name" => "Tanya",
      "last_name" => "Nichols",
      "email" => "tanya.nichols@test.com",
      "company_id" => 2,
      "email_status" => true,
      "active_status" => false,
      "tokens" => 23
    }
  end

  let(:invalid_attributes) { {} }

  describe '#initialize' do
    context 'with valid attributes' do
      let(:user) { described_class.new(valid_attributes) }

      it 'creates a user with the correct id' do
        expect(user.id).to eq(1)
      end

      it 'creates a user with the correct first name' do
        expect(user.first_name).to eq('Tanya')
      end

      it 'creates a user with the correct last name' do
        expect(user.last_name).to eq('Nichols')
      end

      it 'creates a user with the correct email' do
        expect(user.email).to eq('tanya.nichols@test.com')
      end

      it 'creates a user with the correct company id' do
        expect(user.company_id).to eq(2)
      end

      it 'creates a user with the correct email status' do
        expect(user.email_status).to be(true)
      end

      it 'creates a user with the correct active status' do
        expect(user.active_status).to be(false)
      end

      it 'creates a user with the correct tokens' do
        expect(user.tokens).to eq(23)
      end

      it 'creates a user with the correct full name' do
        expect(user.send(:full_name)).to eq('Nichols, Tanya')
      end
    end

    context 'with invalid attributes' do
      it 'raises an error if missing id' do
        expect { described_class.new(invalid_attributes) }.to raise_error(RuntimeError, "User missing id")
      end
    end
  end

  describe '#formatted_user_info' do
    let(:user) { described_class.new(valid_attributes) }

    it 'returns formatted user info with previous balance' do
      formatted_info = user.formatted_user_info(100, 150)
      expect(formatted_info[:previous_balance]).to eq(100)
    end

    it 'returns formatted user info with new balance' do
      formatted_info = user.formatted_user_info(100, 150)
      expect(formatted_info[:new_balance]).to eq(150)
    end

    it 'returns formatted user info with name' do
      formatted_info = user.formatted_user_info(100, 150)
      expect(formatted_info[:name]).to eq('Nichols, Tanya')
    end

    it 'returns formatted user info with email' do
      formatted_info = user.formatted_user_info(100, 150)
      expect(formatted_info[:email]).to eq('tanya.nichols@test.com')
    end
  end

  describe '#full_name' do
    it 'returns the full name in the correct format' do
      user = described_class.new(valid_attributes)
      expect(user.send(:full_name)).to eq('Nichols, Tanya')
    end

    it 'handles missing first name' do
      user = described_class.new(valid_attributes.merge(first_name: nil))
      expect(user.send(:full_name)).to eq('Nichols, unknown')
    end

    it 'handles missing last name' do
      user = described_class.new(valid_attributes.merge(last_name: nil))
      expect(user.send(:full_name)).to eq('unknown, Tanya')
    end
  end
end