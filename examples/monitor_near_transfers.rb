#!/usr/bin/env ruby -Ilib -I../lib
require 'near'

trap(:SIGINT) { abort '' }

NEAR.mainnet.fetch_blocks do |block|
  warn block.inspect if ARGV.include?('-d')

  block.find_actions(:Transfer) do |transfer, transaction|
    warn "\t" + transaction.inspect if ARGV.include?('-d')
    warn "\t\t" + transfer.inspect if ARGV.include?('-d')

    puts "Transferred #{transfer.deposit.inspect} from #{transaction.signer} to #{transaction.receiver}"
  end
end
