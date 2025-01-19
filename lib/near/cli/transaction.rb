# This is free and unencumbered software released into the public domain.

##
# @see https://github.com/near/near-cli-rs/blob/main/docs/GUIDE.en.md#transaction---Operate-transactions
module NEAR::CLI::Transaction
  ##
  # Views status of a transaction.
  #
  # @param [String] tx_hash The transaction hash
  # @return [Hash] Transaction status and details
  def view_status(tx_hash)
    stdout, _ = execute(
      'transaction',
      'view-status', tx_hash,
      'network-config', @network
    )

    # Parse the transaction details from the output
    parse_transaction_status(stdout)
  end

  ##
  # Reconstructs a CLI command from an existing transaction.
  #
  # @param [String] tx_hash The transaction hash
  # @return [Hash] The reconstructed transaction details and CLI command
  def reconstruct_transaction(tx_hash)
    stdout, _ = execute(
      'transaction',
      'reconstruct-transaction', tx_hash,
      'network-config', @network
    )

    {
      transaction: parse_transaction_reconstruction(stdout),
      cli_command: extract_cli_command(stdout)
    }
  end

  ##
  # Constructs a new transaction with multiple actions.
  #
  # @param [String] signer_id Account that signs the transaction
  # @param [String] receiver_id Account that receives the transaction
  # @param [Array<Hash>] actions Array of action hashes, each containing :type and :args
  # @return [String] Base64-encoded unsigned transaction
  def construct_transaction(signer_id, receiver_id, actions)
    args = [
      'transaction',
      'construct-transaction',
      signer_id,
      receiver_id
    ]

    actions.each do |action|
      args += construct_action_args(action)
    end

    args += [
      'network-config', @network
    ]

    stdout, _ = execute(*args)
    extract_unsigned_transaction(stdout)
  end

  ##
  # Signs a previously prepared unsigned transaction.
  #
  # @param [String] unsigned_tx Base64-encoded unsigned transaction
  # @param [Hash] options Signing options (e.g., :keychain, :ledger, :private_key)
  # @return [String] Base64-encoded signed transaction
  def sign_transaction(unsigned_tx, options = {})
    args = [
      'transaction',
      'sign-transaction',
      unsigned_tx,
      'network-config', @network
    ]

    args += case options[:method]
    when :keychain
      ['sign-with-keychain']
    when :ledger
      ['sign-with-ledger']
    when :private_key
      [
        'sign-with-plaintext-private-key',
        options[:private_key]
      ]
    else
      raise ArgumentError, "Invalid signing method: #{options[:method]}"
    end

    stdout, _ = execute(*args)
    extract_signed_transaction(stdout)
  end

  ##
  # Sends a signed transaction.
  #
  # @param [String] signed_tx Base64-encoded signed transaction
  # @return [Hash] Transaction result
  def send_signed_transaction(signed_tx)
    stdout, stderr = execute(
      'transaction',
      'send-signed-transaction',
      signed_tx,
      'network-config', @network
    )

    parse_transaction_result(stderr)
  end

  ##
  # Sends a meta transaction (relayed transaction).
  #
  # @param [String] signed_tx Base64-encoded signed transaction
  # @return [Hash] Transaction result
  def send_meta_transaction(signed_tx)
    stdout, stderr = execute(
      'transaction',
      'send-meta-transaction',
      signed_tx,
      'network-config', @network
    )

    parse_transaction_result(stderr)
  end

  private

  def parse_transaction_status(output)
    # Parse the detailed transaction status output
    # This would need to handle all the various fields from the transaction status
    {
      status: extract_status(output),
      receipts: extract_receipts(output),
      outcome: extract_outcome(output)
    }
  end

  def parse_transaction_reconstruction(output)
    # Parse the transaction reconstruction output
    {
      signer_id: extract_signer(output),
      receiver_id: extract_receiver(output),
      actions: extract_actions(output)
    }
  end

  def construct_action_args(action)
    case action[:type]
    when :create_account
      ['add-action', 'create-account']
    when :transfer
      ['add-action', 'transfer', action[:args][:amount].to_cli_arg]
    when :add_key
      construct_add_key_args(action[:args])
    when :delete_key
      ['add-action', 'delete-key', action[:args][:public_key]]
    when :deploy
      ['add-action', 'deploy', action[:args][:code_path]]
    when :function_call
      [
        'add-action', 'function-call',
        action[:args][:method_name],
        'json-args', action[:args][:args].to_json,
        '--prepaid-gas', action[:args][:gas],
        '--attached-deposit', action[:args][:deposit].to_cli_arg
      ]
    else
      raise ArgumentError, "Unknown action type: #{action[:type]}"
    end
  end

  def construct_add_key_args(args)
    base_args = ['add-action', 'add-key']

    if args[:permission] == :full_access
      base_args + ['grant-full-access']
    else
      base_args + [
        'grant-function-call-access',
        '--allowance', args[:allowance].to_cli_arg,
        '--receiver-account-id', args[:receiver_id],
        '--method-names', Array(args[:method_names]).join(',')
      ]
    end + [
      'use-manually-provided-public-key', args[:public_key]
    ]
  end

  def parse_transaction_result(output)
    {
      success: output.include?('Transaction sent'),
      transaction_id: extract_transaction_id(output),
      message: output
    }
  end

  def extract_unsigned_transaction(output)
    # Extract the base64 unsigned transaction from output
    output[/Unsigned transaction: ([A-Za-z0-9+\/=]+)/, 1]
  end

  def extract_signed_transaction(output)
    # Extract the base64 signed transaction from output
    output[/Signed transaction: ([A-Za-z0-9+\/=]+)/, 1]
  end

  def extract_transaction_id(output)
    output[/Transaction ID: ([A-Za-z0-9]+)/, 1]
  end

  def extract_cli_command(output)
    output[/Here is your console command[^\n]*\n\s*(near.+)$/, 1]
  end

  # Additional helper methods for parsing transaction status output
  def extract_status(output)
    # Extract status from transaction status output
  end

  def extract_receipts(output)
    # Extract receipts from transaction status output
  end

  def extract_outcome(output)
    # Extract outcome from transaction status output
  end

  def extract_signer(output)
    output[/signer_id:\s+(\S+)/, 1]
  end

  def extract_receiver(output)
    output[/receiver_id:\s+(\S+)/, 1]
  end

  def extract_actions(output)
    # Extract and parse actions list from output
    actions = []
    output.scan(/-- ([^:]+):\s+(.+)$/) do |type, details|
      actions << {
        type: type.strip.downcase.to_sym,
        details: details.strip
      }
    end
    actions
  end
end # NEAR::CLI::Transaction
