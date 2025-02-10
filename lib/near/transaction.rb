# This is free and unencumbered software released into the public domain.

##
# Represents a NEAR transaction.
class NEAR::Transaction
  ##
  # The maximum byte size of a NEAR transaction.
  #
  # @see https://github.com/near/nearcore/blob/3a584c2/core/parameters/res/runtime_configs/parameters.snap#L187
  MAX_SIZE = 1_572_864

  ##
  # @param [Hash] json
  # @return [NEAR::Transaction]
  def self.parse(json)
    tx_data = json['transaction']
    NEAR::Transaction.new(tx_data['hash'], data: tx_data)
  end

  ##
  # @param [String, #to_s] hash
  # @param [Hash, #to_h] data
  # @return [void]
  def initialize(hash, data: nil)
    @hash = hash.to_s
    @data = data.to_h if data
  end

  ##
  # The transaction hash.
  #
  # @return [String]
  attr_reader :hash

  ##
  # The transaction data, if available.
  #
  # @return [Hash]
  attr_reader :data

  ##
  # The transaction signer account.
  #
  # @return [NEAR::Account]
  attr_reader :signer
  def signer
    @signer ||= NEAR::Account.new(self.signer_id)
  end

  ##
  # The transaction signer ID.
  #
  # @return [String]
  attr_reader :signer_id
  def signer_id
    self.data['signer_id']
  end

  ##
  # The transaction receiver account.
  #
  # @return [NEAR::Account]
  attr_reader :receiver
  def receiver
    @receiver ||= NEAR::Account.new(self.receiver_id)
  end

  ##
  # The transaction receiver ID.
  #
  # @return [String]
  attr_reader :receiver_id
  def receiver_id
    self.data['receiver_id']
  end

  ##
  # @return [String]
  attr_reader :public_key
  def public_key
    self.data['public_key']
  end

  ##
  # @return [String]
  attr_reader :signature
  def signature
    self.data['signature']
  end

  ##
  # @return [Integer]
  attr_reader :nonce
  def nonce
    self.data['nonce']
  end

  ##
  # @return [Integer]
  attr_reader :priority_fee
  def priority_fee
    self.data['priority_fee']
  end

  ##
  # The transaction actions.
  #
  # @return [Array<Hash>]
  attr_reader :actions
  def actions
    self.data['actions']
  end

  ##
  # @yield [NEAR::Action]
  # @yieldparam [NEAR::Action] action
  # @yieldreturn [void]
  # @return [Enumerator] if no block is given
  def each_action(&)
    return enum_for(:each_action) unless block_given?
    self.data['actions'].each do |action|
      yield NEAR::Action.parse(action)
    end
  end

  ##
  # @return [String]
  def to_s; @hash; end

  ##
  # @return [Hash]
  def to_h; @data; end

  ##
  # @return [String]
  def inspect
    "#<#{self.class.name} hash: #{@hash.inspect}, signer: #{self.signer}, receiver: #{self.receiver}, actions: #{self.actions.size}>"
  end
end # NEAR::Transaction
