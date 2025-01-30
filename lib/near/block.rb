# This is free and unencumbered software released into the public domain.

##
# Represents a NEAR block.
class NEAR::Block
  ##
  # @return [NEAR::Block]
  def self.now
    self.new
  end

  ##
  # @param [Integer, #to_i] height
  # @return [NEAR::Block]
  def self.at_height(height)
    self.new(height: height)
  end

  ##
  # @param [String, #to_s] hash
  # @return [NEAR::Block]
  def self.at_hash(hash)
    self.new(hash: hash)
  end

  ##
  # @param [Integer, #to_i] height
  # @param [String, #to_s] hash
  # @param [Hash, #to_h] data
  def initialize(height: nil, hash: nil, data: nil)
    @height = height.to_i if height
    @hash = hash.to_s if hash
    @data = data.to_h if data
  end

  ##
  # The height of the block.
  #
  # @return [Integer]
  attr_reader :height

  ##
  # The hash of the block.
  #
  # @return [String]
  attr_reader :hash

  ##
  # The block data, if fetched.
  #
  # @return [Hash]
  attr_reader :data

  ##
  # @return [String]
  def author
    self.data['block']['author']
  end

  ##
  # @return [Hash]
  def header
    self.data['block']['header']
  end

  ##
  # @return [Array<Hash>]
  def chunks
    self.data['block']['chunks']
  end

  ##
  # @return [Array<Hash>]
  def shards
    self.data['shards']
  end

  ##
  # @return [Array<String>]
  def to_cli_args
    return ['at-block-height', @height] if @height
    return ['at-block-hash', @hash] if @hash
    ['now']
  end

  ##
  # @return [Integer]
  def to_i; @height; end

  ##
  # @return [String]
  def to_s
    (@height || @hash || :now).to_s
  end

  ##
  # @return [Hash]
  def to_h; @data; end
end # NEAR::Block
