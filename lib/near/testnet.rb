# This is free and unencumbered software released into the public domain.

require_relative 'network'

##
# Represents the NEAR Testnet.
#
# @see https://docs.near.org/concepts/basics/networks#testnet
class NEAR::Testnet < NEAR::Network
  NEARDATA_URL = 'https://testnet.neardata.xyz'.freeze

  ##
  # @return [void]
  def initialize
    super(:testnet)
  end
end # NEAR::Testnet
