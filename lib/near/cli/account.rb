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
  # @param [NEAR::Account, #to_s] new_account
  # @param [String, nil] public_key
  # @return [String]
  def create_account_with_faucet(new_account, public_key: nil)
    stdout, stderr = execute(
      'account',
      'create-account',
      'sponsor-by-faucet-service', new_account.to_s,
      *case public_key
        when nil then ['autogenerate-new-keypair', 'save-to-keychain']
        when String then ['use-manually-provided-public-key', public_key]
        when Array then public_key
        else raise ArgumentError
      end,
      'network-config', @network,
      'create'
    )
    stderr
  end

  ##
  # Creates a new account funded by another account.
  #
  # @param [NEAR::Account, #to_s] new_account
  # @param [NEAR::Account, #to_s] signer Account that signs & funds the transaction
  # @param [String, nil] public_key
  # @param [NEAR::Balance, #to_s] deposit Amount of NEAR to attach
  # @return [String]
  def create_account_with_funding(new_account, signer:, public_key: nil, deposit: nil)
    stdout, stderr = execute(
      'account',
      'create-account',
      'fund-myself', new_account.to_s, (deposit ? deposit.to_s : '0') + ' NEAR',
      *case public_key
        when nil then ['autogenerate-new-keypair', 'save-to-keychain']
        when String then ['use-manually-provided-public-key', public_key]
        when Array then public_key
        else raise ArgumentError
      end,
      'sign-as', signer.to_s,
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
  # @param [NEAR::Account] account
  # @param [NEAR::Account] beneficiary
  # @return [String]
  def delete_account(account, beneficiary: nil)
    account = NEAR::Account.parse(account)
    stdout, stderr = execute(
      'account',
      'delete-account', account.to_s,
      'beneficiary', (beneficiary || account.parent).to_s,
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
