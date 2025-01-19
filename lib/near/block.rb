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
  def initialize(height: nil, hash: nil)
    @height = height.to_i if height
    @hash = hash.to_s if hash
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
  # @return [Array<String>]
  def to_args
    return ['at-block-height', @height] if @height
    return ['at-block-hash', @hash] if @hash
    ['now']
  end

  ##
  # @return [String]
  def to_s
    (@height || @hash || :now).to_s
  end
end # NEAR::Block
