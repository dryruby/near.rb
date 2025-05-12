# NEAR.rb: NEAR for Ruby

[![License](https://img.shields.io/badge/license-Public%20Domain-blue.svg)](https://unlicense.org)
[![Compatibility](https://img.shields.io/badge/ruby-3.0%2B-blue)](https://rubyreferences.github.io/rubychanges/3.0.html)
[![Package](https://img.shields.io/gem/v/near)](https://rubygems.org/gems/near)
[![Documentation](https://img.shields.io/badge/rubydoc-latest-blue)](https://rubydoc.info/gems/near)

**NEAR.rb** is a [Ruby] client library for the [NEAR Protocol].
It provides a [neardata.xyz] API client for block data as well as wraps the
[NEAR Command-Line Interface] (CLI) in a high-productivity Ruby interface.

## ✨ Features

- Fetches block data from the [neardata.xyz] API.
- Supports parsing of block, chunk, transaction, and action data.
- Wraps the complete CLI features in an idiomatic Ruby interface.
- Provides comprehensive account management operations.
- Supports token operations for NEAR and other assets.
- Supports smart contract deployment and interaction.
- Handles transaction construction, signing, and monitoring.
- Integrates with hardware wallets and secure key storage.
- Implements type-safe balance operations and input validation.
- Supports both the [mainnet] and [testnet] environments.
- Offers cross-platform support with zero library dependencies.
- 100% free and unencumbered public domain software.

## 🛠️ Prerequisites

- [NEAR CLI] 0.18+
- [Ruby] 3.0+

## ⬇️ Installation

### Installation via RubyGems

```bash
gem install near
```

## 👉 Examples

- [Importing the library](#importing-the-library)
- [Fetching block information](#fetching-block-information)
- [Tracking block production](#tracking-block-production)
- [Tracking chain transactions](#tracking-chain-transactions)
- [Tracking chain actions](#tracking-chain-actions)
- [Tracking contract interactions](#tracking-contract-interactions)
- [Instantiating the CLI wrapper](#instantiating-the-cli-wrapper)
- [Viewing account details](#viewing-account-details)
- [Importing accounts](#importing-accounts)
- [Creating accounts](#creating-accounts)
- [Deleting accounts](#deleting-accounts)
- [Managing access keys](#managing-access-keys)
- [Managing tokens](#managing-tokens)
- [Calling read-only contract methods](#calling-read-only-contract-methods)
- [Calling mutative contract methods](#calling-mutative-contract-methods)
- [Deploying a smart contract](#deploying-a-smart-contract)

### Importing the library

```ruby
require 'near'
```

### Fetching block information

Block data is fetched from the high-performance [neardata.xyz] API
that caches blocks using Cloudflare's network with more than 330
global edge locations:

```ruby
block = NEAR.testnet.fetch(186_132_854)
```

### Tracking block production

Thanks to the built-in [neardata.xyz] API client, it is trivial to
track the current tip of the chain in a robust and efficient manner:

```ruby
NEAR.testnet.fetch_blocks do |block|
  puts [block.height, block.hash].join("\t")
end
```

### Tracking chain transactions

```ruby
NEAR.testnet.fetch_blocks do |block|
  puts block.inspect

  block.each_transaction do |transaction|
    puts "\t" + transaction.inspect
  end
end
```

For a more elaborated example, see
[`examples/monitor_all_transactions.rb`](examples/monitor_all_transactions.rb):

[![monitor_all_transactions.rb](examples/monitor_all_transactions.gif)](examples/monitor_all_transactions.gif)

### Tracking chain actions

```ruby
NEAR.testnet.fetch_blocks do |block|
  puts block.inspect

  block.each_action do |action|
    puts "\t" + action.inspect
  end
end
```

For a more elaborated example, see
[`examples/monitor_all_actions.rb`](examples/monitor_all_actions.rb):

[![monitor_all_actions.rb](examples/monitor_all_actions.gif)](examples/monitor_all_actions.gif)

### Tracking contract interactions

```ruby
NEAR.testnet.fetch_blocks do |block|
  puts block.inspect

  block.find_actions(:FunctionCall, receiver: 'aurora', method_name: /^submit/) do |action|
    puts "\t" + action.inspect
  end
end
```

For a more elaborated example, see
[`examples/index_evm_transactions.rb`](examples/index_evm_transactions.rb):

[![index_evm_transactions.rb](examples/index_evm_transactions.gif)](examples/index_evm_transactions.gif)

### Instantiating the CLI wrapper

```ruby
# Use the NEAR testnet (the default):
testnet = NEAR::CLI.new(network: NEAR.testnet)

# Use the NEAR mainnet (to test in prod):
# mainnet = NEAR::CLI.new(network: NEAR.mainnet)
```

### Viewing account details

```ruby
# View an account summary:
summary = testnet.view_account_summary('arto.testnet')
puts summary

# View an account at a specific block height:
summary = testnet.view_account_summary('arto.testnet',
  block: 185_304_186
)

# View an account at a specific block hash:
summary = testnet.view_account_summary('arto.testnet',
  block: '13UmYhdcdst88aC19QhjYjNMF1zRmaAyY6iqwc5q45bx'
)

# List access keys in an account:
keys = testnet.list_keys('arto.testnet')
puts keys
```

### Importing accounts

```ruby
# Import an account using a seed phrase:
result = testnet.import_account_with_seed_phrase(
  'rapid cover napkin accuse junk drill sick tooth poem patch evil fan',
  hd_path: "m/44'/397'/0'"
)

# Import an account using a private key:
result = testnet.import_account_with_private_key(
  'ed25519:5YhAaEe3G4VtiBavJMvpzPPmknfsTauzVjwK1ZjPVw2MFM6zFyUv4tSiSfCbCn78mEnMifE6iX5qbhFsWEwErcC2'
)
```

### Creating accounts

```ruby
# Create an account funded from a faucet (testnet only):
result = testnet.create_account_with_faucet(
  'mynewaccount.testnet',
  public_key: 'ed25519:HVPgAsZkZ7cwLZDqK313XJsDyqAvgBxrATcD7VacA8KE'
)

# Create an account funded by another account:
result = testnet.create_account_with_funding(
  'sub.example.testnet',           # new account
  'example.testnet',               # funding account
  'ed25519:6jm8hWUgwoEeGmpdEyk9zrCqtXM8kHhvg8M236ZaGusS',  # public key
  '1 NEAR'                         # initial deposit
)

# Create a new implicit account:
result = testnet.create_implicit_account('/path/to/credentials/folder')
```

### Deleting accounts

```ruby
# Delete an existing account:
result = testnet.delete_account(
  'my-obsolete-account.testnet',                # account to delete
  beneficiary: 'v2.faucet.nonofficial.testnet'  # account receiving remaining balance
)
```

### Managing access keys

```ruby
# Add a full-access key to an account:
result = testnet.add_full_access_key(
  'myaccount.testnet',
  'ed25519:75a5ZgVZ9DFTxs4THtFxPtLj7AY3YzpxtapTQBdcMXx3'
)

# Add a function-call key to an account:
result = testnet.add_function_call_key(
  'myaccount.testnet',
  'ed25519:27R66L6yevyHbsk4fESZDC8QUQBwCdx6vvkk1uQmG7NY',
  'app.example.testnet',           # contract that can be called
  ['set_status', 'get_status'],    # allowed methods
  '1 NEAR'                         # allowance
)

# Delete an access key from an account:
result = testnet.delete_key(
  'myaccount.testnet',
  'ed25519:75a5ZgVZ9DFTxs4THtFxPtLj7AY3YzpxtapTQBdcMXx3'
)
```

### Managing tokens

```ruby
# Send NEAR tokens from one account to another:
result = testnet.send_near(
  'mysender.testnet',
  'myreceiver.testnet',
  NEAR::Balance.new('0.1')
)
```

### Calling read-only contract methods

```ruby
# Call a view method:
result = testnet.view_call(
  'myapp.testnet',                # contract account
  'get_status',                   # method name
  { account_id: 'user.testnet' }  # arguments
)

# Call a view method at a specific block height:
result = testnet.view_call(
  'myapp.testnet',
  'get_status',
  { account_id: 'user.testnet' },
  block: 12345678
)
```

### Calling mutative contract methods

```ruby
# Call a mutative method as a transaction:
result = testnet.call_function(
  'myapp.testnet',            # contract account
  'set_status',               # method name
  { status: 'Hello NEAR!' },  # arguments
  signer_id: 'user.testnet',  # account that signs tx
  deposit: '1 NEAR',          # attached deposit
  gas: '30 TGas'              # attached gas
)
```

### Deploying a smart contract

```ruby
# Deploy a new contract:
result = testnet.deploy_contract(
  'myapp.testnet',            # contract account
  '/tmp/contract.wasm',       # WASM file path
  signer_id: 'deployer.testnet',
  # Optional initialization:
  init_method: 'new',
  init_args: { owner_id: 'deployer.testnet' },
  init_deposit: '0 NEAR',
  init_gas: '30 TGas'
)

# Download a contract WebAssembly blob:
result = testnet.download_wasm(
  'myapp.testnet',
  '/tmp/contract.wasm'
)
```

## 📚 Reference

https://rubydoc.info/gems/near

## 👨‍💻 Development

```bash
git clone https://github.com/dryruby/near.rb.git
```

---

[![Share on X](https://img.shields.io/badge/share%20on-x-03A9F4?logo=x)](https://x.com/intent/post?url=https://github.com/dryruby/near.rb&text=NEAR.rb)
[![Share on Reddit](https://img.shields.io/badge/share%20on-reddit-red?logo=reddit)](https://reddit.com/submit?url=https://github.com/dryruby/near.rb&title=NEAR.rb)
[![Share on Hacker News](https://img.shields.io/badge/share%20on-hn-orange?logo=ycombinator)](https://news.ycombinator.com/submitlink?u=https://github.com/dryruby/near.rb&t=NEAR.rb)
[![Share on Facebook](https://img.shields.io/badge/share%20on-fb-1976D2?logo=facebook)](https://www.facebook.com/sharer/sharer.php?u=https://github.com/dryruby/near.rb)
[![Share on LinkedIn](https://img.shields.io/badge/share%20on-linkedin-3949AB?logo=linkedin)](https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/dryruby/near.rb)

[NEAR CLI]: https://github.com/near/near-cli-rs
[NEAR Protocol]: https://near.org
[NEAR command-line interface]: https://docs.near.org/tools/near-cli
[Ruby]: https://ruby-lang.org
[mainnet]: https://docs.near.org/concepts/basics/networks#mainnet
[testnet]: https://docs.near.org/concepts/basics/networks#testnet
[neardata.xyz]: https://neardata.xyz
