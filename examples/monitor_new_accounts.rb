#!/usr/bin/env ruby -Ilib -I../lib
require 'near'

trap(:SIGINT) { abort '' }

NEAR.testnet.fetch_blocks do |block|
  warn block.inspect if ARGV.include?('-d')

  block.find_actions(:CreateAccount) do |action, transaction|
    warn "\t" + transaction.inspect if ARGV.include?('-d')
    warn "\t\t" + action.inspect if ARGV.include?('-d')

    puts "Created the new account #{transaction.receiver}"
  end
end
