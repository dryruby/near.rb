# This is free and unencumbered software released into the public domain.

require 'faraday'
require 'faraday/follow_redirects'
require 'faraday/retry'

require_relative 'error'

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
  # Fetches a block range.
  #
  # The block data is fetched from the neardata.xyz API.
  #
  # @param [NEAR::Block, #to_i] from
  # @param [NEAR::Block, #to_i] to
  # @yield [NEAR::Block]
  # @yieldparam [NEAR::Block] block
  # @yieldreturn [void]
  # @return [Enumerator]
  def fetch_blocks(from: nil, to: nil, &)
    return enum_for(:fetch_blocks) unless block_given?
    from = self.fetch_latest.height unless from
    from, to = from.to_i, to&.to_i
    (from..to).each do |block_height|
      yield self.fetch(block_height)
    end
  end

  ##
  # Fetches the block at the given height.
  #
  # The block data is fetched from the neardata.xyz API.
  #
  # @param [NEAR::Block, #to_i] block
  # @return [NEAR::Block]
  # @raise [NEAR::Error::InvalidBlock] if the block does not exist
  def fetch(block)
    self.fetch_neardata_block(block.to_i)
  end

  ##
  # Fetches the latest finalized block.
  #
  # The block data is fetched from the neardata.xyz API.
  # The block is guaranteed to exist.
  #
  # @return [NEAR::Block]
  def fetch_latest
    self.fetch_neardata_block(:final)
  end

  protected

  ##
  # @param [Integer, Symbol] block_id
  # @return [NEAR::Block]
  def fetch_neardata_block(block_id)
    request_path = case block_id
      when Integer then "/v0/block/#{block_id}"
      when Symbol then "/v0/last_block/#{block_id}"
      else raise ArgumentError
    end

    begin
      block_data = self.fetch_neardata_url(request_path)
    rescue Faraday::ResourceNotFound => error
      case error.response[:body]['type']
        when "BLOCK_DOES_NOT_EXIST", "BLOCK_HEIGHT_TOO_LOW", "BLOCK_HEIGHT_TOO_HIGH"
          raise NEAR::Error::InvalidBlock, block_id
        else raise NEAR::Error::UnexpectedProblem
      end
    end

    return nil if block_data.nil? || block_data == 'null'
    block_header = block_data['block']['header']
    block_height = block_header['height'].to_i
    block_hash = block_header['hash'].to_s
    NEAR::Block.new(height: block_height, hash: block_hash, data: block_data)
  end

  ##
  # @return [Object]
  def fetch_neardata_url(path)
    begin
      retries ||= 0
      self.http_client.get("#{neardata_url}#{path}").body
    rescue Faraday::ConnectionFailed => error
      # `Faraday::Retry` doesn't seem able to handle `ConnectionFailed`,
      # so we'll handle it manually here. Note that in case of a DNS error,
      # there's no point in retrying, so we'll wrap & re-raise the error.
      case error.wrapped_exception
        when Socket::ResolutionError then raise NEAR::Error::TemporaryProblem
        else retry if (retries += 1) < 3
      end
      raise NEAR::Error::UnexpectedProblem
    end
  end

  ##
  # @return [Faraday::Connection]
  def http_client
    Faraday.new do |faraday|
      faraday.response :raise_error
      faraday.response :follow_redirects
      faraday.response :json
      faraday.request :retry, {
        max: 3,
        exceptions: Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS + [Faraday::ConnectionFailed]
      }.freeze
    end
  end
end # NEAR::Testnet
