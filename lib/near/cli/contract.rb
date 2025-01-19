# This is free and unencumbered software released into the public domain.

##
# @see https://github.com/near/near-cli-rs/blob/main/docs/GUIDE.en.md#contract---Manage-smart-contracts-deploy-code-call-functions
module NEAR::CLI::Contract
  ##
  # Calls a view method on a contract (read-only).
  #
  # @param [String] contract_id
  # @param [String] method_name
  # @param [Hash] args JSON arguments for the method
  # @param [Block, Integer, String, Symbol] block
  # @return [String] The method call result
  def view_call(contract_id, method_name, args = {}, block: :now)
    stdout, _ = execute(
      'contract',
      'call-function',
      'as-read-only', contract_id, method_name,
      'json-args', args.to_json,
      'network-config', @network,
      *block_args(block)
    )
    stdout
  end

  ##
  # Calls a state-changing method on a contract.
  #
  # @param [String] contract_id
  # @param [String] method_name
  # @param [Hash] args JSON arguments for the method
  # @param [String] signer_id Account that signs the transaction
  # @param [String] deposit Amount of NEAR to attach
  # @param [String] gas Amount of gas to attach
  # @return [String] Transaction result
  def call_function(contract_id, method_name, args = {}, signer_id:, deposit: '0 NEAR', gas: '30 TGas')
    stdout, stderr = execute(
      'contract',
      'call-function',
      'as-transaction', contract_id, method_name,
      'json-args', args.to_json,
      'prepaid-gas', gas,
      'attached-deposit', deposit,
      'sign-as', signer_id,
      'network-config', @network,
      'sign-with-keychain',
      'send'
    )
    stderr
  end
  alias_method :call_method, :call_function

  ##
  # Deploys a new contract.
  #
  # @param [String] contract_id Account to deploy the contract to
  # @param [String] wasm_path Path to the .wasm file
  # @param [String] signer_id Account that signs the transaction
  # @param [String, nil] init_method Method to call after deployment
  # @param [Hash] init_args Arguments for the init method
  # @param [String] init_deposit Deposit for the init method
  # @param [String] init_gas Gas for the init method
  # @return [String] Transaction result
  def deploy_contract(contract_id, wasm_path, signer_id:, init_method: nil, init_args: {},
                     init_deposit: '0 NEAR', init_gas: '30 TGas')
    args = [
      'contract',
      'deploy',
      contract_id,
      'use-file', wasm_path
    ]

    if init_method
      args += [
        'with-init-call', init_method,
        'json-args', init_args.to_json,
        'prepaid-gas', init_gas,
        'attached-deposit', init_deposit
      ]
    end

    args += [
      'sign-as', signer_id,
      'network-config', @network,
      'sign-with-keychain',
      'send'
    ]

    stdout, stderr = execute(*args)
    stderr
  end

  ##
  # Downloads a contract's WASM code.
  #
  # @param [String] contract_id
  # @param [String] output_path Path to write the .wasm file to
  # @param [Block, Integer, String, Symbol] block
  # @return [String] Path to downloaded file
  def download_wasm(contract_id, output_path, block: :now)
    _, _ = execute(
      'contract',
      'download-wasm', contract_id,
      'save-to-file', output_path,
      'network-config', @network,
      *block_args(block)
    )
    output_path
  end

  ##
  # Views contract storage state with JSON formatting.
  #
  # @param [String] contract_id
  # @param [String, nil] prefix Filter keys by prefix
  # @param [Block, Integer, String, Symbol] block
  # @return [String] Contract storage state
  def view_storage(contract_id, prefix: nil, block: :now)
    args = [
      'contract',
      'view-storage', contract_id
    ]

    args += if prefix
      ['keys-start-with-string', prefix]
    else
      ['all']
    end

    args += [
      'as-json',
      'network-config', @network,
      *block_args(block)
    ]

    stdout, _ = execute(*args)
    stdout
  end

  ##
  # Views contract storage state with base64 key filtering.
  #
  # @param [String] contract_id
  # @param [String] base64_prefix Filter keys by base64 prefix
  # @param [Block, Integer, String, Symbol] block
  # @return [String] Contract storage state
  def view_storage_base64(contract_id, base64_prefix, block: :now)
    stdout, _ = execute(
      'contract',
      'view-storage', contract_id,
      'keys-start-with-bytes-as-base64', base64_prefix,
      'as-json',
      'network-config', @network,
      *block_args(block)
    )
    stdout
  end
end # NEAR::CLI::Contract
