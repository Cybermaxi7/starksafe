# Starksafe - Secure Smart Contract Wallet for Starknet

Starksafe is a secure, user-friendly smart contract wallet built on Starknet, featuring advanced security features including social recovery and multi-signature functionality.

## 🚀 Features

- **Smart Contract Wallet** - Secure account abstraction on Starknet
- **Social Recovery** - Recover access with help from trusted contacts
- **Multi-signature Support** - Enhanced security with multiple signers
- **Gasless Transactions** - Support for sponsored transactions
- **Web Interface** - Intuitive React/Next.js frontend

## 🛠 Tech Stack

- **Smart Contracts**: Cairo 2.0
- **Frontend**: Next.js 14, TypeScript, Tailwind CSS
- **Wallet Integration**: @starknet-react, starknet.js
- **Testing**: Starknet Foundry (snForge)
- **CI/CD**: GitHub Actions

## 📦 Project Structure

```
starksafe/
├── contracts/         # Cairo smart contracts
│   ├── src/           # Contract source files
│   └── tests/         # Test files
└── frontend/          # Next.js frontend
    ├── src/           # Source files
    └── public/        # Static assets
```

## 🚀 Getting Started

### Prerequisites

- Node.js 18+
- Python 3.9+
- Scarb (Cairo package manager)
- Starknet Foundry (snForge)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Cybermaxi7/starksafe.git
   cd starksafe
   ```

2. **Set up the development environment**
   ```bash
   # Install dependencies
   npm install
   
   # Install Scarb (Cairo package manager)
   curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
   
   # Install Starknet Foundry
   curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh
   ```

## 🧪 Testing

Run the test suite:

```bash
cd contracts
scarb test
```

## 🌐 Running Locally

1. **Start the development server**
   ```bash
   cd frontend
   npm run dev
   ```

2. Open [http://localhost:3000](http://localhost:3000) in your browser

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Starknet community
- Starknet Foundry team
- All contributors and supporters
