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

  ##
  # Lists access keys for an account.
  #
  # @param [String] account_id
  # @param [Block, Integer, String, Symbol] block
  # @return [String]
  def list_keys(account_id, block: :now)
    stdout, _ = execute(
      'account',
      'list-keys', account_id,
      'network-config', @network,
      *block_args(block)
    )
    stdout
  end

  ##
  # Imports an existing account using a seed phrase.
  #
  # @param [String] seed_phrase
  # @param [String] hd_path
  # @return [String]
  def import_account_with_seed_phrase(seed_phrase, hd_path: "m/44'/397'/0'")
    _, stderr = execute(
      'account',
      'import-account',
      'using-seed-phrase', seed_phrase,
      '--seed-phrase-hd-path', hd_path,
      'network-config', @network
    )
    stderr
  end

  ##
  # Imports an existing account using a private key.
  #
  # @param [String] private_key
  # @return [String]
  def import_account_with_private_key(private_key)
    _, stderr = execute(
      'account',
      'import-account',
      'using-private-key', private_key,
      'network-config', @network
    )
    stderr
  end

  ##
  # Creates a new account sponsored by the faucet service.
  #
  # @param [String] new_account_id
  # @param [String] public_key
  # @return [String]
  def create_account_with_faucet(new_account_id, public_key)
    stdout, stderr = execute(
      'account',
      'create-account',
      'sponsor-by-faucet-service', new_account_id,
      'use-manually-provided-public-key', public_key,
      'network-config', @network,
      'create'
    )
    stderr
  end

  ##
  # Creates a new account funded by another account.
  #
  # @param [String] new_account_id
  # @param [String] funding_account_id
  # @param [String] public_key
  # @param [String] deposit
  # @return [String]
  def create_account_with_funding(new_account_id, funding_account_id, public_key, deposit)
    stdout, stderr = execute(
      'account',
      'create-account',
      'fund-myself', new_account_id, deposit,
      'use-manually-provided-public-key', public_key,
      'sign-as', funding_account_id,
      'network-config', @network,
      'sign-with-keychain',
      'send'
    )
    stderr
  end

  ##
  # Creates an implicit account.
  #
  # @param [String] save_path
  # @return [String]
  def create_implicit_account(save_path)
    stdout, stderr = execute(
      'account',
      'create-account',
      'fund-later',
      'use-auto-generation',
      'save-to-folder', save_path
    )
    stderr
  end

  ##
  # Deletes an account and transfers remaining balance to beneficiary.
  #
  # @param [String] account_id
  # @param [String] beneficiary_id
  # @return [String]
  def delete_account(account_id, beneficiary_id)
    stdout, stderr = execute(
      'account',
      'delete-account', account_id,
      'beneficiary', beneficiary_id,
      'network-config', @network,
      'sign-with-keychain',
      'send'
    )
    stderr
  end

  ##
  # Adds a full access key to an account.
  #
  # @param [String] account_id
  # @param [String] public_key
  # @return [String]
  def add_full_access_key(account_id, public_key)
    stdout, stderr = execute(
      'account',
      'add-key', account_id,
      'grant-full-access',
      'use-manually-provided-public-key', public_key,
      'network-config', @network,
      'sign-with-keychain',
      'send'
    )
    stderr
  end

  ##
  # Adds a function call access key to an account.
  #
  # @param [String] account_id
  # @param [String] public_key
  # @param [String] receiver_id
  # @param [Array<String>] method_names
  # @param [String] allowance
  # @return [String]
  def add_function_call_key(account_id, public_key, receiver_id, method_names, allowance)
    stdout, stderr = execute(
      'account',
      'add-key', account_id,
      'grant-function-call-access',
      '--allowance', allowance,
      '--receiver-account-id', receiver_id,
      '--method-names', method_names.join(', '),
      'use-manually-provided-public-key', public_key,
      'network-config', @network,
      'sign-with-keychain',
      'send'
    )
    stderr
  end

  ##
  # Deletes an access key from an account.
  #
  # @param [String] account_id
  # @param [String] public_key
  # @return [String]
  def delete_key(account_id, public_key)
    stdout, stderr = execute(
      'account',
      'delete-key', account_id,
      public_key,
      'network-config', @network,
      'sign-with-keychain',
      'send'
    )
    stderr
  end

  ##
  # Views storage balance for an account.
  #
  # @param [String] contract_id
  # @param [String] account_id
  # @param [Block, Integer, String, Symbol] block
  # @return [String]
  def view_storage_balance(contract_id, account_id, block: :now)
    stdout, _ = execute(
      'account',
      'manage-storage-deposit', contract_id,
      'view-balance', account_id,
      'network-config', @network,
      *block_args(block)
    )
    stdout
  end

  ##
  # Makes a storage deposit for an account.
  #
  # @param [String] contract_id
  # @param [String] account_id
  # @param [String] deposit
  # @param [String] sign_as
  # @return [String]
  def make_storage_deposit(contract_id, account_id, deposit, sign_as)
    stdout, stderr = execute(
      'account',
      'manage-storage-deposit', contract_id,
      'deposit', account_id, deposit,
      'sign-as', sign_as,
      'network-config', @network,
      'sign-with-keychain',
      'send'
    )
    stderr
  end

  ##
  # Withdraws storage deposit for an account.
  #
  # @param [String] contract_id
  # @param [String] amount
  # @param [String] account_id
  # @return [String]
  def withdraw_storage_deposit(contract_id, amount, account_id)
    stdout, stderr = execute(
      'account',
      'manage-storage-deposit', contract_id,
      'withdraw', amount,
      'sign-as', account_id,
      'network-config', @network,
      'sign-with-keychain',
      'send'
    )
    stderr
  end
end # NEAR::CLI::Account
