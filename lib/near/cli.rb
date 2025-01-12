# This is free and unencumbered software released into the public domain.

require 'json'
require 'open3'

class NEAR::CLI
  NEAR_ENV = ENV['NEAR_ENV'] || 'testnet'

  class Error < StandardError; end
  class ProgramNotFoundError < Error; end
  class ExecutionError < Error; end

  def self.find_program
    # First, check `$HOME/.cargo/bin/near`:
    path = File.expand_path('~/.cargo/bin/near')
    return path if File.executable?(path)

    # Next, check `$PATH`:
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      path = File.join(path, 'near')
      return path if File.executable?(path)
    end

    raise ProgramNotFoundError
  end

  ##
  # @param [String, #to_s] path
  # @param [String, #to_s] network
  def initialize(path: self.class.find_program, network: NEAR_ENV)
    @path = path.to_s
    @network = network.to_s
  end

  ##
  # @return [String]
  def version
    self.execute(self.build_command('--version'))
  end

  ##
  # @param [String] account_id
  # @param [String] block
  # @return [String]
  def view_near_balance(account_id, block: 'now')
    _, output = execute(
      'tokens',
      account_id,
      'view-near-balance',
      'network-config', @network,
      block
    )
    /^#{account_id} account has (\d+.\d+) NEAR available for transfer/ === output
    $1
  end

  ##
  # @param [String] account_id
  # @param [String] block
  # @return [String]
  def view_account_summary(account_id, block: 'now')
    _, output = execute(
      'account',
      'view-account-summary', account_id,
      'network-config', @network,
      block
    )
    output # TODO
  end

  private

  def execute(*args)
    command = [@path, *args.map(&:to_s)]
    #puts command.join(' ')
    stdout, stderr, status = Open3.capture3(*command)

    if status.success?
      [stdout.strip, stderr.strip]
    else
      raise ExecutionError, "Command `#{command.join(' ')}` failed with exit code #{status.exitstatus}: #{stderr}"
    end
  end
end # NEAR::CLI
