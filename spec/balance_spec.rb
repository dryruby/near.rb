# This is free and unencumbered software released into the public domain.

require 'near'

RSpec.describe NEAR::Balance do
  describe '#initialize' do
    context 'with valid input' do
      it 'accepts an integer' do
        balance = NEAR::Balance.new(100)
        expect(balance.to_i).to eq(100)
      end

      it 'accepts a float' do
        balance = NEAR::Balance.new(100.5)
        expect(balance.to_f).to eq(100.5)
      end

      it 'accepts a rational' do
        balance = NEAR::Balance.new(Rational(201, 2))
        expect(balance.to_r).to eq(Rational(201, 2))
      end

      it 'accepts a decimal' do
        balance = NEAR::Balance.new(BigDecimal('123.45'))
        expect(balance.to_f).to eq(123.45)
      end

      it 'accepts a string' do
        balance = NEAR::Balance.new('123.45')
        expect(balance.to_f).to eq(123.45)
      end
    end

    context 'with invalid input' do
      it 'raises ArgumentError for invalid strings' do
        expect { NEAR::Balance.new('invalid') }.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError for nil' do
        expect { NEAR::Balance.new(nil) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#inspect' do
    it 'returns the balance as a Ⓝ-prefixed string' do
      balance = NEAR::Balance.new(100.5)
      expect(balance.inspect).to eq('Ⓝ100.5')
    end
  end

  describe '#to_s' do
    it 'returns the balance as a string' do
      balance = NEAR::Balance.new(100.5)
      expect(balance.to_s).to eq('100.5')
    end
  end

  describe '#to_r' do
    it 'returns the balance as a rational' do
      balance = NEAR::Balance.new(Rational(201, 2))
      expect(balance.to_r).to eq(Rational(201, 2))
    end
  end

  describe '#to_i' do
    it 'returns the balance as an integer' do
      balance = NEAR::Balance.new(100.5)
      expect(balance.to_i).to eq(100)
    end
  end

  describe '#to_f' do
    it 'returns the balance as a float' do
      balance = NEAR::Balance.new(100)
      expect(balance.to_f).to eq(100.0)
    end
  end
end
