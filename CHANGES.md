# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.3.0 - 2025-02-02

### Added
- Implement block data accessors
- Implement transaction data accessors
- Implement action parsing

### Changed
- Adopt Faraday as the HTTP client
- Improve HTTP error handling and retries

## 0.2.0 - 2025-01-29

### Added
- `Network#fetch(block)`
- `NEAR.testnet`, `NEAR.mainnet`

### Changed
- Use the NEAR_CLI environmnet variable, if set
- Use a temporary file for `call_function`
- Enhance `call_function()`
- Enhance `create_account_with_funding()`
- Enhance `delete_account()`

### Fixed
- Fix the formatting of balances

## 0.1.0 - 2025-01-19

## 0.0.0 - 2025-01-11
