# 🎓 Diploma NFT Registry

## 🚀 Pitch / Description
This project enables the creation and management of a decentralized diploma registry using NFTs on the Sui blockchain. Educational institutions can issue verifiable digital diplomas to students, ensuring authenticity and transparency.

## 🏗️ Architecture Overview
- **Sui Blockchain**: Underlying platform for smart contracts and transactions.
- **Registry Module**: Manages issuers and diploma records.
- **Diploma Module**: Handles minting of diploma NFTs.
- **Client CLI**: Interface to interact with the blockchain and modules.

## ⚙️ Prerequisites
- Install [Sui CLI](https://docs.sui.io/build/install) and ensure it is configured.
- Rust environment for building and publishing modules.
- Basic familiarity with command-line operations.

## 🛠️ Setup Instructions

### 1. Start Sui Node with Faucet
```bash
RUST_LOG="off,sui_node=info" sui start --with-faucet --force-regenesis
```

### 2. Create and Switch to Local Environment
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

## 💡 Usage

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
  --args <REGISTRY_OBJECT_ID> \
        <ISSUER_ADDRESS> \
        <STUDENT_ADDRESS> \
        "0x68617368" \                  # hash or identifier
        "0x42616368656c6f72204353" \    # diploma type e.g. "Bachelor CS"
        "0x556e6976657273697479" \      # institution e.g. "University"
        2025                            # year
```

## 🎬 Demo
*Screenshots and videos demonstrating the registry, issuer addition, and diploma minting will be added here.*

## 👥 Team
- Justin Pessia
- Rabah [Last Name]
- Timeo [Last Name]

*Feel free to contribute and reach out for collaboration!*
