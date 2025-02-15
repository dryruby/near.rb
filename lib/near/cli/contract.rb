# This is free and unencumbered software released into the public domain.

require "base64"
require "pathname"

##
# @see https://github.com/near/near-cli-rs/blob/main/docs/GUIDE.en.md#contract---Manage-smart-contracts-deploy-code-call-functions
module NEAR::CLI::Contract
  ##
  # Calls a view method on a contract (read-only).
  #
  # @param [NEAR::Account] contract
  # @param [String] method_name
  # @param [Hash] args JSON arguments for the method
  # @param [Block, Integer, String, Symbol] block
  # @return [String] The method call result
  def view_call(contract, method_name, args = {}, block: :now)
    stdout, _ = execute(
      'contract',
      'call-function',
      'as-read-only', contract.to_s, method_name,
      'json-args', args.to_json,
      'network-config', @network,
      *block_args(block)
    )
    stdout
  end

  ##
  # Calls a state-changing method on a contract.
  #
  # @param [NEAR::Account] contract
  # @param [String] method_name
  # @param [Hash, Array, String, Pathname] args Arguments for the method
  # @param [NEAR::Account] signer Account that signs the transaction
  # @param [NEAR::Balance] deposit Amount of NEAR to attach
  # @param [NEAR::Gas, #to_s] gas Amount of gas to attach
  # @return [String] Transaction result
  def call_function(contract, method_name, args = {}, signer: nil, deposit: nil, gas: '100.0 Tgas')
    args = case args
      when Hash, Array then ['json-args', args.to_json]
      when String then case args
        when /[^[:print:]]/ then ['base64-args', Base64.strict_encode64(args)]
        else ['text-args', args]
      end
      when Pathname then ['file-args', args.to_s]
      else raise ArgumentError, "Invalid argument type: #{args.inspect}"
    end
    stdout, stderr = execute(
      'contract',
      'call-function',
      'as-transaction', contract.to_s, method_name.to_s,
      *args,
      'prepaid-gas', gas.to_s,
      'attached-deposit', (deposit ? deposit.to_s : '0') + ' NEAR',
      'sign-as', (signer || contract).to_s,
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
  # @param [NEAR::Account, #to_s] contract Account to deploy the contract to
  # @param [String] wasm_path Path to the .wasm file
  # @param [String, nil] init_method Method to call after deployment
  # @param [Hash] init_args Arguments for the init method
  # @param [String] init_deposit Deposit for the init method
  # @param [String] init_gas Gas for the init method
  # @return [String] Transaction result
  def deploy_contract(contract, wasm_path, init_method: nil, init_args: {},
                     init_deposit: '0 NEAR', init_gas: '30 TGas')
    args = [
      'contract',
      'deploy',
      contract.to_s,
      'use-file', wasm_path
    ]

    args += if init_method
      [
        'with-init-call', init_method,
        'json-args', init_args.to_json,
        'prepaid-gas', init_gas,
        'attached-deposit', init_deposit
      ]
    else
      ['without-init-call']
    end

    args += [
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
