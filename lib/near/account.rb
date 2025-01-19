# This is free and unencumbered software released into the public domain.

##
# Represents a NEAR account.
#
# @see https://nomicon.io/DataStructures/Account
class NEAR::Account
  ##
  # @param [String, #to_s] id
  def initialize(id)
    @id = id.to_s
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
