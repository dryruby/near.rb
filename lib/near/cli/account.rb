# This is free and unencumbered software released into the public domain.

##
# @see https://github.com/near/near-cli-rs/blob/main/docs/GUIDE.en.md#account---Manage-accounts
module NEAR::CLI::Account
  ##
  # Views properties for an account.
  #
  # @param [String] account_id
  # @param [Block, Integer, String, Symbol] block
  # @return [String]
  def view_account_summary(account_id, block: :now)
    stdout, _ = execute(
      'account',
      'view-account-summary', account_id,
      'network-config', @network,
      *block_args(block)
    )
    stdout
  end
end # NEAR::CLI::Account
