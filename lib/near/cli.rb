# This is free and unencumbered software released into the public domain.

require 'json'
require 'open3'

require_relative 'block'

class NEAR::CLI; end

require_relative 'cli/account'
require_relative 'cli/config'
require_relative 'cli/contract'
require_relative 'cli/staking'
require_relative 'cli/tokens'
require_relative 'cli/transaction'

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
    @path, @network = path.to_s, network.to_s
  end

  ##
  # @return [String]
  def version
    self.execute('--version').first.strip
  end

  include NEAR::CLI::Account
  include NEAR::CLI::Tokens
  include NEAR::CLI::Staking
  include NEAR::CLI::Contract
  include NEAR::CLI::Transaction
  include NEAR::CLI::Config

  private

  ##
  # @param [Array<String>] args
  # @return [Array<String>]
  def execute(*args)
    command = [@path, *args.map(&:to_s)]
    puts command.join(' ') if false
    stdout, stderr, status = Open3.capture3(*command)

    if status.success?
      [stdout.strip, stderr.strip]
    else
      raise ExecutionError, "Command `#{command.join(' ')}` failed with exit code #{status.exitstatus}: #{stderr.strip}"
    end
  end

  ##
  # @param [Block, Integer, String, Symbol] block
  def block_args(block)
    block = case block
      when :now then return ['now']
      when NEAR::Block then block
      when Integer then NEAR::Block.at_height(block)
      when String then NEAR::Block.at_hash(block)
      else raise "invalid block specifier: #{block.inspect}"
    end
    block.to_args
  end
end # NEAR::CLI
