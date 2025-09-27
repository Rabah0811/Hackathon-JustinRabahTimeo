0xf5fd046d366a371f22bd305cbcb9ead22f5bc33753b9236f96da9b3f328bc585


Acceder au site admin
cd frontend
python3 -m http.server 5500

http://localhost:5500/admin.html

Dans le TERMINAL A: n’importe ou
RUST_LOG="off,sui_node=info" sui start --with-faucet --force-regenesis

Dans le TERMINAL B: Hackaton
sui client new-env --alias local --rpc http://127.0.0.1:9000
sui client switch --env local
sui client active-env 

sui client addresses
sui client active-address
sui client faucet
sui client gas 


sui client call \
  --package 0xec0e3bc057495a35686512e0e202a4ffe9e5be666ce82a86048fd88e6cf899a7 \
  --module registry \
  --function init_registry \
  --args 0xf5fd046d366a371f22bd305cbcb9ead22f5bc33753b9236f96da9b3f328bc585

sui client call \
  --package 0xec0e3bc057495a35686512e0e202a4ffe9e5be666ce82a86048fd88e6cf899a7 \
  --module registry \
  --function add_issuer \
  --args <REGISTRY_OBJECT_ID> \
        0xf5fd046d366a371f22bd305cbcb9ead22f5bc33753b9236f96da9b3f328bc585 \
        0xf5fd046d366a371f22bd305cbcb9ead22f5bc33753b9236f96da9b3f328bc585


sui client call \
  --package <NOUVEAU_PACKAGE_ID> \
  --module diploma \
  --function mint_diploma_entry \
  --args 0x527ed2f4fa4e9e4996856cc2c5e025aab14080ea6bb7066c80138ba99406eb2f \
        0xf5fd046d366a371f22bd305cbcb9ead22f5bc33753b9236f96da9b3f328bc585 \
        0xf5fd046d366a371f22bd305cbcb9ead22f5bc33753b9236f96da9b3f328bc585 \
        "0x68617368" \
        "0x42616368656c6f72204353" \
        "0x556e6976657273697479" \
        2025