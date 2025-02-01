#!/usr/bin/env ruby -Ilib -I../lib
require 'near'

trap(:SIGINT) { abort '' }

NEAR.mainnet.fetch_blocks do |block|
  warn block.inspect if ARGV.include?('-d')

  block.each_action do |action, transaction|
    warn "\t" + transaction.inspect if ARGV.include?('-d')
    warn "\t\t" + action.inspect if ARGV.include?('-d')

    puts "Processed a #{action.type} from #{transaction.signer} to #{transaction.receiver}"
  end
end
