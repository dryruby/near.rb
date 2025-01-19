# This is free and unencumbered software released into the public domain.

require 'near'

RSpec.describe NEAR::Account do
  describe '#initialize' do
    it 'instantiates an account with the given ID' do
      account = NEAR::Account.new('alice.near')
      expect(account.id).to eq('alice.near')
    end

    it 'converts the input to a string' do
      account = NEAR::Account.new(:'alice.near')
      expect(account.id).to eq('alice.near')
    end
  end

  describe '#inspect' do
    it 'returns the account ID as a Ⓝ-prefixed string' do
      account = NEAR::Account.new('alice.near')
      expect(account.inspect).to eq('Ⓝalice.near')
    end
  end

  describe '#to_s' do
    it 'returns the account ID as a string' do
      account = NEAR::Account.new('alice.near')
      expect(account.to_s).to eq('alice.near')
    end
  end
end
