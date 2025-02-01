#!/usr/bin/env ruby -Ilib -I../lib
require 'near'

trap(:SIGINT) { abort '' }

NEAR.mainnet.fetch_blocks do |block|
  warn block.inspect if ARGV.include?('-d')

  block.each_transaction do |transaction|
    warn "\t" + transaction.inspect if ARGV.include?('-d')

    puts "Submitted a transaction from #{transaction.signer} to #{transaction.receiver}"
  end
end
