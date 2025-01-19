# This is free and unencumbered software released into the public domain.

##
# Represents a NEAR transaction.
class NEAR::Transaction
  ##
  # @param [String, #to_s] hash
  def initialize(hash)
    @hash = hash.to_s
  end

  ##
  # The transaction hash.
  #
  # @return [String]
  attr_reader :hash

  ##
  # @return [String]
  def to_s; @hash; end
end # NEAR::Transaction
