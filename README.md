#  Diploma NFT Registry

## Pitch / Description
This project enables the creation and management of a decentralized diploma registry using NFTs on the Sui blockchain. Educational institutions can issue verifiable digital diplomas to students, ensuring authenticity and transparency.

## Security & Authenticity

- Only certified institutions (registered issuers) can mint diplomas.
- Each diploma is an immutable NFT tied to the student's wallet.
- Diplomas cannot be altered or revoked once issued.
- Employer verification ensures the diploma comes from a trusted issuer.

## Architecture Overview
- **Sui Blockchain**: Underlying platform for smart contracts and transactions.
- **Registry Module**: Manages issuers and diploma records.
- **Diploma Module**: Handles minting of diploma NFTs.
- **Client CLI**: Interface to interact with the blockchain and modules.

## Project Structure

```bash
📦 diploma-nft-registry/
├── 📜 Move.toml
├── 📘 README.md
├── 🔒 sui.lock
├── ⚙️ .gitignore
├── 🏗️ build/
├── 📂 sources/
│   ├── 🗂️ registry.move
│   ├── 🎓 diploma.move
│   └── 🔍 verificateur.move
├── 🧪 tests/
│   └── 🧾 diploma_test.move
└── 📜 scripts/
    ├── 🚀 publish.sh
    ├── 🪪 mint_diploma.sh
    └── ✅ verify_diploma.sh
```



## Prerequisites
- Install [Sui CLI](https://docs.sui.io/build/install) and ensure it is configured.
- Rust environment for building and publishing modules.
- Basic familiarity with command-line operations.

## Setup Instructions for local usage
Once registry.move and diploma.move have been build with sui move build
### 1. Start Sui Node with Faucet on TERMINAL A
```bash
RUST_LOG="off,sui_node=info" sui start --with-faucet --force-regenesis
```
then leave terminal A running
### 2. Create and Switch to Local Environment on TERMINAL B
```bash
sui client new-env --alias local --rpc http://127.0.0.1:9000
sui client switch --env local
sui client active-env
```

### 3. Verify Addresses and Faucet
```bash
sui client addresses
sui client active-address
sui client faucet
sui client gas
```

### 4. Publish Modules
```bash
sui client publish --gas-budget 100000000
```

## Usage

### Initialize Registry
```bash
sui client call \
  --package <PACKAGE_ID_REGISTRY> \
  --module registry \
  --function init_registry \
  --args <ADMIN_ADDRESS>
```

### Add an Issuer
```bash
sui client call \
  --package <PACKAGE_ID_REGISTRY> \
  --module registry \
  --function add_issuer \
  --args <REGISTRY_OBJECT_ID> <ISSUER_ADDRESS>
```

### Mint a Diploma
```bash
sui client call \
  --package <PACKAGE_ID_DIPLOMA> \
  --module diploma \
  --function mint_diploma_entry \
  --args <REGISTRY_ID> \
        <UNIVERSITY_ADDRESS> \
        <STUDENT_WALLET> \
        "0x68617368" \                  # hash or identifier
        "0x42616368656c6f72204353" \    # diploma type e.g. "Bachelor CS"
        "0x556e69766572736974<img width="940" height="150" alt="Screenshot 2025-09-28 at 03 36 54" src="https://github.com/user-attachments/assets/d3a144fc-625f-415a-a0fc-8630098b576e" />
79" \      # institution e.g. "University"
        2025                            # year
```
### Verify a Student's Diplomas

Employers can verify diplomas by calling a function that checks whether a student owns one or more diploma NFTs issued by trusted institutions.

```bash
sui client call \
  --package <PACKAGE_ID> \
  --module verificateur \
  --function verify_student_diplomas \
  --args <STUDENT_ADDRESS>
```
However, all of this is done on the web page and you just have to research someone with its adress:


<img width="940" height="150" alt="Screenshot 2025-09-28 at 03 36 54" src="https://github.com/user-attachments/assets/c3c14f39-ea82-4260-93d8-46bfb03835a5" />


## Future Improvements

- Add expiration/validity metadata to diplomas.
- Include student signatures for extra validation.
- Web frontend for universities and employers.
- IPFS integration for image storage.
- Smart contract versioning and upgrade support.


## Team
- Justin Pessia
- Rabah Belhadj
- Timeo Chaix
