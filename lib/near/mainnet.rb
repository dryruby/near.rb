# This is free and unencumbered software released into the public domain.

require_relative 'network'

##
# Represents the NEAR Mainnet.
#
# @see https://docs.near.org/concepts/basics/networks#mainnet
class NEAR::Mainnet < NEAR::Network
  NEARDATA_URL = 'https://mainnet.neardata.xyz'.freeze

  ##
  # @return [void]
  def initialize
    super(:mainnet)
  end
end # NEAR::Mainnet
