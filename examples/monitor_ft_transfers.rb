#!/usr/bin/env ruby -Ilib -I../lib
require 'near'

trap(:SIGINT) { abort '' }

NEAR.mainnet.fetch_blocks do |block|
  warn block.inspect if ARGV.include?('-d')

  block.find_actions(:FunctionCall, method_name: 'ft_transfer') do |call, transaction|
    warn "\t" + transaction.inspect if ARGV.include?('-d')
    warn "\t\t" + call.inspect if ARGV.include?('-d')

    receiver_id, amount = call[:receiver_id], call[:amount]
    puts "Transferred #{amount} of #{transaction.receiver} from #{transaction.signer} to #{receiver_id}"
  end
end
