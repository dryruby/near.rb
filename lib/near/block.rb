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
  attr_reader :author
  def author
    self.data['block']['author']
  end

  ##
  # The block header.
  #
  # @return [Hash]
  attr_reader :header
  def header
    self.data['block']['header']
  end

  ##
  # @return [Array<Hash>]
  attr_reader :chunks
  def chunks
    self.data['block']['chunks']
  end

  ##
  # @return [Array<Hash>]
  attr_reader :shards
  def shards
    self.data['shards']
  end

  ##
  # The set of signers in the transactions in this block.
  #
  # @return [Array<NEAR::Account>]
  def signers
    self.collect_transaction_field('signer_id')
      .map { |id| NEAR::Account.new(id) }
  end

  ##
  # The set of receivers in the transactions in this block.
  #
  # @return [Array<NEAR::Account>]
  def receivers
    self.collect_transaction_field('receiver_id')
      .map { |id| NEAR::Account.new(id) }
  end

  ##
  # Enumerates the transactions in this block.
  #
  # @yield [NEAR::Transaction]
  # @yieldparam [NEAR::Transaction] transaction
  # @yieldreturn [void]
  # @return [Enumerator] if no block is given
  def each_transaction(&)
    return enum_for(:each_transaction) unless block_given?
    self.each_chunk do |chunk|
      next if !chunk['transactions']
      chunk['transactions'].each do |tx|
        yield NEAR::Transaction.parse(tx)
      end
    end
  end

  ##
  # Enumerates the actions in this block.
  #
  # @yield [NEAR::Action, NEAR::Transaction]
  # @yieldparam [NEAR::Action] action
  # @yieldparam [NEAR::Transaction] transaction
  # @yieldreturn [void]
  # @return [Enumerator] if no block is given
  def each_action(&)
    return enum_for(:each_action) unless block_given?
    self.each_transaction do |tx|
      tx.each_action do |action|
        yield action, tx
      end
    end
  end

  ##
  # @param [Symbol, #to_sym] type
  # @param [String, Regexp] signer
  # @param [String, Regexp] receiver
  # @param [String, Regexp] method_name
  # @yield [NEAR::Action, NEAR::Transaction]
  # @yieldparam [NEAR::Action] action
  # @yieldparam [NEAR::Transaction] transaction
  # @yieldreturn [void]
  # @return [Enumerator] if no block is given
  def find_actions(type, signer: nil, receiver: nil, method_name: nil, &)
    return enum_for(:each_action) unless block_given?
    type = type.to_sym
    self.each_transaction do |tx|
      next if signer && !(signer === tx.signer_id)
      next if receiver && !(receiver === tx.receiver_id)
      tx.each_action do |action|
        next unless type == action.type
        next if method_name && !(method_name === action.method_name)
        yield action, tx
      end
    end
  end

  ##
  # Enumerates the chunks in this block.
  #
  # @yield [Hash]
  # @yieldparam [Hash] chunk
  # @yieldreturn [void]
  # @return [Enumerator] if no block is given
  def each_chunk(&)
    return enum_for(:each_chunk) unless block_given?
    self.shards.each do |shard|
      chunk = shard['chunk']
      yield chunk if chunk
    end
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

  ##
  # @return [String]
  def inspect
    "#<#{self.class.name} height: #{@height}, hash: #{@hash.inspect}>"
  end

  protected

  ##
  # @param [String] field
  # @return [Array<String>]
  def collect_transaction_field(field)
    result = {}
    self.shards.each do |shard|
      shard['chunk']['transactions'].each do |tx|
        result[tx['transaction']['receiver_id']] = true
      end
    end
    result.keys
  end
end # NEAR::Block
