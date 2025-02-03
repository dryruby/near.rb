#!/usr/bin/env ruby -Ilib -I../lib
require 'near'

trap(:SIGINT) { abort '' }

testnet = NEAR::CLI.new(network: NEAR.testnet)

fund_account = NEAR::Account.parse(ARGV.shift || "v2.faucet.nonofficial.testnet")
temp_account = NEAR::Account.temp

warn "Creating account #{temp_account}..."
testnet.create_account_with_faucet(temp_account)

sleep 3

warn "Deleting account #{temp_account}..."
testnet.delete_account(temp_account, beneficiary: fund_account)
