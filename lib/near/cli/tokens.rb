# This is free and unencumbered software released into the public domain.

##
# @see https://github.com/near/near-cli-rs/blob/main/docs/GUIDE.en.md#tokens---Manage-token-assets-such-as-NEAR-FT-NFT
module NEAR::CLI::Tokens
  ##
  # Sends NEAR tokens from one account to another.
  #
  # @param [String] sender_id The account sending the tokens
  # @param [String] receiver_id The account receiving the tokens
  # @param [NEAR::Balance] amount The amount to send
  # @return [Hash] Transaction result
  def send_near(sender_id, receiver_id, amount)
    raise ArgumentError, "amount must be a NEAR::Balance" unless amount.is_a?(NEAR::Balance)

    _, stderr = execute(
      'tokens',
      sender_id,
      'send-near', receiver_id, amount.to_cli_arg,
      'network-config', @network,
      'sign-with-keychain',
      'send'
    )

    # Extract transaction details from stderr:
    if stderr.include?('Transaction sent')
      tx_match = stderr.match(/Transaction ID: ([A-Za-z0-9]+)/)
      tx_id = tx_match ? tx_match[1] : nil
      {
        success: true,
        transaction_id: tx_id,
        message: stderr.strip
      }
    else
      {
        success: false,
        message: stderr.strip
      }
    end
  end

  ##
  # Views the NEAR token balance of an account.
  #
  # @param [String] account_id The account to check
  # @param [Block, Integer, String, Symbol] block The block to query (default: :now)
  # @return [Hash] Balance information including available and total balance
  def view_near_balance(account_id, block: :now)
    _, stderr = execute(
      'tokens',
      account_id,
      'view-near-balance',
      'network-config', @network,
      *block_args(block)
    )

    # Parse the balance information from stderr:
    available_match = stderr.match(/(\d+\.?\d*) NEAR available for transfer/)
    total_match = stderr.match(/total balance is (\d+\.?\d*) NEAR/)
    locked_match = stderr.match(/(\d+\.?\d*) NEAR is locked/)

    {
      account_id: account_id,
      available_balance: available_match ? NEAR::Balance.from_near(available_match[1]) : nil,
      total_balance: total_match ? NEAR::Balance.from_near(total_match[1]) : nil,
      locked_balance: locked_match ? NEAR::Balance.from_near(locked_match[1]) : nil,
      block: block,
    }
  end
end # NEAR::CLI::Tokens
