# This is free and unencumbered software released into the public domain.

##
# Represents a NEAR account.
#
# @see https://nomicon.io/DataStructures/Account
class NEAR::Account
  ##
  # @param [String, #to_s] id
  # @return [NEAR::Account]
  def self.parse(id)
    self.new(id.to_s)
  end

  ##
  # @return [NEAR::Account]
  def self.temp
    timestamp = (Time.now.to_f * 1_000).to_i
    self.new("temp-#{timestamp}.testnet")
  end

  ##
  # @param [String, #to_s] id
  def initialize(id)
    @id = id.to_s
  end

  ##
  # @return [NEAR::Account]
  def parent
    return nil unless @id.include?('.')
    self.class.new(@id.split('.').drop(1).join('.'))
  end

  ##
  # The account name.
  #
  # @return [String]
  attr_reader :id

  ##
  # The balance as a Ⓝ-prefixed string.
  #
  # @return [String]
  def inspect
    "Ⓝ#{@id}"
  end

  ##
  # @return [String]
  def to_s; @id; end
end # NEAR::Block
