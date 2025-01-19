# This is free and unencumbered software released into the public domain.

require 'near'

RSpec.describe NEAR::Block do
  describe '.now' do
    it 'instantiates a block representing the current state' do
      block = NEAR::Block.now
      expect(block.height).to be_nil
      expect(block.hash).to be_nil
    end
  end

  describe '.at_height' do
    it 'instantiates a block for a specific height' do
      block = NEAR::Block.at_height(185_299_288)
      expect(block.height).to eq(185_299_288)
      expect(block.hash).to be_nil
    end

    it 'converts the height to an integer' do
      block = NEAR::Block.at_height('185299288')
      expect(block.height).to eq(185_299_288)
    end
  end

  describe '.at_hash' do
    it 'instantiates a block for a specific hash' do
      block = NEAR::Block.at_hash('8Y5HyGLa5oX42bWm21neXTNLTQrE4yhGMWs4GLhTywzk')
      expect(block.hash).to eq('8Y5HyGLa5oX42bWm21neXTNLTQrE4yhGMWs4GLhTywzk')
      expect(block.height).to be_nil
    end

    it 'converts the hash to a string' do
      block = NEAR::Block.at_hash(:'8Y5HyGLa5oX42bWm21neXTNLTQrE4yhGMWs4GLhTywzk')
      expect(block.hash).to eq('8Y5HyGLa5oX42bWm21neXTNLTQrE4yhGMWs4GLhTywzk')
    end
  end

  describe '#to_cli_args' do
    it 'returns ["now"] for the current block' do
      block = NEAR::Block.now
      expect(block.to_cli_args).to eq(['now'])
    end

    it 'returns height arguments for height-based blocks' do
      block = NEAR::Block.at_height(185_299_288)
      expect(block.to_cli_args).to eq(['at-block-height', 185_299_288])
    end

    it 'returns hash arguments for hash-based blocks' do
      block = NEAR::Block.at_hash('8Y5HyGLa5oX42bWm21neXTNLTQrE4yhGMWs4GLhTywzk')
      expect(block.to_cli_args).to eq(['at-block-hash', '8Y5HyGLa5oX42bWm21neXTNLTQrE4yhGMWs4GLhTywzk'])
    end
  end

  describe '#to_s' do
    it 'returns "now" for the current block' do
      block = NEAR::Block.now
      expect(block.to_s).to eq('now')
    end

    it 'returns the height for height-based blocks' do
      block = NEAR::Block.at_height(185_299_288)
      expect(block.to_s).to eq('185299288')
    end

    it 'returns the hash for hash-based blocks' do
      block = NEAR::Block.at_hash('8Y5HyGLa5oX42bWm21neXTNLTQrE4yhGMWs4GLhTywzk')
      expect(block.to_s).to eq('8Y5HyGLa5oX42bWm21neXTNLTQrE4yhGMWs4GLhTywzk')
    end
  end
end
