# This is free and unencumbered software released into the public domain.

##
# Represents a NEAR block.
class NEAR::Block
  ##
  # @param [Integer] height
  # @return [NEAR::Block]
  def self.at_height(height)
    self.new(height: height)
  end

  ##
  # @param [String] hash
  # @return [NEAR::Block]
  def self.at_hash(hash)
    self.new(hash: hash)
  end

  ##
  # @param [Integer, nil] height
  # @param [String, nil] hash
  def initialize(height: nil, hash: nil)
    @height = height if height
    @hash = hash if hash
  end

  ##
  # @return [Array(String)]
  def to_args
    return ['at-block-height', @height] if @height
    return ['at-block-hash', @hash] if @hash
    ['now']
  end

  ##
  # @return [String]
  def to_s
    (@height || @hash || 'now').to_s
  end
end # NEAR::Block
