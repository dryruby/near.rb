# This is free and unencumbered software released into the public domain.

require 'faraday'
require 'faraday/follow_redirects'

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
    self.fetch_neardata("/v0/block/#{block.to_i}")
  end

  ##
  # Fetches the latest finalized block.
  #
  # The block data is fetched from the neardata.xyz API.
  # The block is guaranteed to exist.
  #
  # @return [Object]
  def fetch_latest
    self.fetch_neardata("/v0/last_block/final")
  end

  protected

  ##
  # @return [Object]
  def fetch_neardata(path)
    response = self.http_client.get("#{neardata_url}#{path}")
    case response.status
      when 200 then JSON.parse(response.body)
      when 404 then nil
      else raise response.to_s
    end
  end

  ##
  # @return [Faraday::Connection]
  def http_client
    Faraday.new do |faraday|
      faraday.response :follow_redirects
    end
  end
end # NEAR::Testnet
