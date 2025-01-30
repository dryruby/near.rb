# This is free and unencumbered software released into the public domain.

require 'faraday'
require 'faraday/follow_redirects'
require 'faraday/retry'

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
  # @return [NEAR::Block]
  def fetch(block)
    self.fetch_neardata_block("/v0/block/#{block.to_i}")
  end

  ##
  # Fetches the latest finalized block.
  #
  # The block data is fetched from the neardata.xyz API.
  # The block is guaranteed to exist.
  #
  # @return [NEAR::Block]
  def fetch_latest
    self.fetch_neardata_block("/v0/last_block/final")
  end

  protected

  ##
  # @return [NEAR::Block]
  def fetch_neardata_block(path)
    block_data = self.fetch_neardata_url(path)
    return nil unless block_data
    block_header = block_data['block']['header']
    block_height = block_header['height'].to_i
    block_hash = block_header['hash'].to_s
    NEAR::Block.new(height: block_height, hash: block_hash, data: block_data)
  end

  ##
  # @return [Object]
  def fetch_neardata_url(path)
    self.http_client.get("#{neardata_url}#{path}").body
  rescue Faraday::ResourceNotFound
    nil
  end

  ##
  # @return [Faraday::Connection]
  def http_client
    Faraday.new do |faraday|
      faraday.request :retry
      faraday.response :raise_error
      faraday.response :follow_redirects
      faraday.response :json
    end
  end
end # NEAR::Testnet
