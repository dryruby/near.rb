# This is free and unencumbered software released into the public domain.

require 'json'
require 'open3'

class NEAR::CLI
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

  def initialize(path = self.class.find_program)
    @path = path
  end

  def version
    self.execute(self.build_command('--version'))
  end

  private

  def build_command(*args)
    [@path, *args.map(&:to_s)]
  end

  def execute(cmd)
    stdout, stderr, status = Open3.capture3(*cmd)

    if status.success?
      stdout.strip
    else
      raise ExecutionError, "Command failed: #{stderr}"
    end
  end
end # NEAR::CLI
