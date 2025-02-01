#!/usr/bin/env ruby -Ilib -I../lib
require 'near'

trap(:SIGINT) { abort '' }

NEAR.mainnet.fetch_blocks do |block|
  warn block.inspect if ARGV.include?('-d')

  block.find_actions(:FunctionCall, receiver: 'aurora', method_name: /^submit/) do |submit, transaction|
    warn "\t" + transaction.inspect if ARGV.include?('-d')
    warn "\t\t" + submit.inspect if ARGV.include?('-d')

    puts "Submitted an EVM transaction from '#{transaction.signer}' to '#{transaction.receiver}'"
  end
end
