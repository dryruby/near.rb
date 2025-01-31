# This is free and unencumbered software released into the public domain.

module NEAR; end

require_relative 'near/account'
require_relative 'near/action'
require_relative 'near/balance'
require_relative 'near/block'
require_relative 'near/cli'
require_relative 'near/error'
require_relative 'near/mainnet'
require_relative 'near/network'
require_relative 'near/testnet'
require_relative 'near/transaction'
require_relative 'near/version'

module NEAR
  ##
  # @return [NEAR::Testnet]
  def self.testnet
    @testnet ||= Testnet.new
  end

  ##
  # @return [NEAR::Mainnet]
  def self.mainnet
    @mainnet ||= Mainnet.new
  end
end
