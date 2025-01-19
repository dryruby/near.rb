# This is free and unencumbered software released into the public domain.

##
# @see https://github.com/near/near-cli-rs/blob/main/docs/GUIDE.en.md#tokens---Manage-token-assets-such-as-NEAR-FT-NFT
module NEAR::CLI::Tokens
  ##
  # Views the balance of NEAR tokens.
  #
  # @param [String] account_id
  # @param [Block, Integer, String, Symbol] block
  # @return [String]
  def view_near_balance(account_id, block: :now)
    _, stderr = execute(
      'tokens',
      account_id,
      'view-near-balance',
      'network-config', @network,
      *block_args(block)
    )
    /^#{account_id} account has (\d+.\d+) NEAR available for transfer/ === stderr
    $1
  end
end # NEAR::CLI::Tokens
