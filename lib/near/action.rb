# This is free and unencumbered software released into the public domain.

require 'base64'

##
# Represents a NEAR action.
#
# @see https://nomicon.io/RuntimeSpec/Actions
class NEAR::Action
  class CreateAccount < NEAR::Action; end

  class DeployContract < NEAR::Action; end

  class FunctionCall < NEAR::Action
    ##
    # @return [String]
    attr_reader :method_name
    def method_name
      @data['method_name']
    end

    ##
    # @return [String]
    attr_reader :args
    def args
      @args ||= Base64.decode64(@data['args'])
    end

    ##
    # @return [Integer]
    attr_reader :gas
    def gas
      @data['gas']
    end

    ##
    # @return [NEAR::Balance]
    attr_reader :deposit
    def deposit
      @deposit ||= NEAR::Balance.new(@data['deposit'])
    end
  end

  class Transfer < NEAR::Action; end

  class Stake < NEAR::Action; end

  class AddKey < NEAR::Action; end

  class DeleteKey < NEAR::Action; end

  class DeleteAccount < NEAR::Action; end

  class Delegate < NEAR::Action; end

  ##
  # @param [Hash, #to_h] data
  # @return [NEAR::Action]
  def self.parse(data)
    data = data.to_h
    case
      when data['CreateAccount'] then CreateAccount.new(data['CreateAccount'])
      when data['DeployContract'] then DeployContract.new(data['DeployContract'])
      when data['FunctionCall'] then FunctionCall.new(data['FunctionCall'])
      when data['Transfer'] then Transfer.new(data['Transfer'])
      when data['Stake'] then Stake.new(data['Stake'])
      when data['AddKey'] then AddKey.new(data['AddKey'])
      when data['DeleteKey'] then DeleteKey.new(data['DeleteKey'])
      when data['DeleteAccount'] then DeleteAccount.new(data['DeleteAccount'])
      when data['Delegate'] then Delegate.new(data['Delegate'])
      else self.new(data[data.keys.first])
    end
  end

  ##
  # @param [Hash, #to_h] data
  def initialize(data)
    @data = data.to_h if data
  end

  ##
  # The action data.
  #
  # @return [Hash]
  attr_reader :data

  ##
  # @return [Hash]
  def to_h; @data; end
end # NEAR::Block
