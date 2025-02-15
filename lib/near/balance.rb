# This is free and unencumbered software released into the public domain.

require 'bigdecimal'

##
# Represents a NEAR balance.
class NEAR::Balance
  def self.parse(s)
    self.new(s.to_f / 10**24)
  end

  def self.from_near(s)
    self.new(s)
  end

  ##
  # @param [Numeric] quantity
  # @raise [ArgumentError] if quantity is not a valid number
  def initialize(quantity)
    @quantity = case quantity
      when BigDecimal then quantity
      when Rational then quantity
      when Integer then quantity
      when Float then quantity
      when String then BigDecimal(quantity)
      else raise ArgumentError, "invalid quantity: #{quantity.inspect}"
    end
  end

  ##
  # The canonical zero balance.
  ZERO = self.new(0).freeze

  ##
  # The balance as a Ⓝ-prefixed string.
  #
  # @return [String]
  def inspect
    "Ⓝ #{@quantity.to_f}"
  end

  ##
  # The balance as a string.
  #
  # @return [String]
  def to_s
    case @quantity
      when BigDecimal then @quantity.to_s('F')
      else @quantity.to_s
    end
  end

  ##
  # The balance as a rational number.
  #
  # @return [Rational]
  def to_r; @quantity.to_r; end

  ##
  # The balance as an integer.
  #
  # @return [Integer]
  def to_i; @quantity.to_i; end

  ##
  # The balance as a floating-point number.
  #
  # @return [Float]
  def to_f; @quantity.to_f; end
end # NEAR::Balance
