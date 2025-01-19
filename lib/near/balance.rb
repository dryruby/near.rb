# This is free and unencumbered software released into the public domain.

##
# Represents a NEAR balance.
class NEAR::Balance
  ##
  # @param [Numeric] quantity
  def initialize(quantity)
    @quantity = case quantity
      when Rational then quantity
      when Integer then quantity
      when Float then quantity
      else raise ArgumentError, "invalid quantity: #{quantity.inspect}"
    end
  end

  ##
  # The balance as a string.
  #
  # @return [String]
  def to_s; @quantity.to_s; end

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
