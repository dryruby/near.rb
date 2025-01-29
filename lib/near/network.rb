# This is free and unencumbered software released into the public domain.

require 'net/http'

##
# Represents a NEAR Protocol network.
#
# @see https://docs.near.org/concepts/basics/networks
class NEAR::Network
  ##
  # @param [Symbol, #to_sym] id
  # @return [void]
  def initialize(id)
    @id = id.to_sym
  end

  ##
  # @return [String]
  def to_s; @id.to_s; end

  ##
  # @return [String]
  def neardata_url
    self.class.const_get(:NEARDATA_URL)
  end

  ##
  # Fetches the block at the given height.
  #
  # The block data is fetched from the neardata.xyz API.
  # If the block does not exist, `nil` is returned.
  #
  # @param [NEAR::Block, #to_i] block
  # @return [Object]
  def fetch(block)
    response = Net::HTTP.get_response(URI("#{neardata_url}/v0/block/#{block.to_i}"))
    case response
      when Net::HTTPSuccess then JSON.parse(response.body)
      when Net::HTTPNotFound then nil
      else raise response.to_s
    end
  end
end # NEAR::Testnet
