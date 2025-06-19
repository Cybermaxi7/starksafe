"use client";
import { useState } from "react";
import { useAccount } from "@starknet-react/core";
import { Contract, RpcProvider } from "starknet";
import StarknetProvider from "../../components/StarknetProvider";
import WalletBar from "../../components/WalletBar";

const ABI = [
  {
    "type": "function",
    "name": "owner",
    "inputs": [],
    "outputs": [{ "type": "core::starknet::contract_address::ContractAddress" }],
    "state_mutability": "view"
  },
  {
    "type": "function",
    "name": "nonce",
    "inputs": [],
    "outputs": [{ "type": "core::integer::u64" }],
    "state_mutability": "view"
  },
  {
    "type": "function",
    "name": "transfer_ownership",
    "inputs": [{ "name": "new_owner", "type": "core::starknet::contract_address::ContractAddress" }],
    "outputs": [],
    "state_mutability": "external"
  }
];


export default function AccountPage() {
  return (
    <StarknetProvider>
      <WalletBar />
      <AccountDashboard />
    </StarknetProvider>
  );
}

function AccountDashboard() {
  const { address, isConnected } = useAccount();
  const [contractAddress, setContractAddress] = useState("");
  const [owner, setOwner] = useState("");
  const [nonce, setNonce] = useState("");
  const [newOwner, setNewOwner] = useState("");
  const [status, setStatus] = useState("");

  async function fetchInfo() {
    if (!contractAddress) return;
    const provider = new RpcProvider({ nodeUrl: "https://starknet-testnet.public.blastapi.io/rpc/v0_6" });
    const contract = new Contract(ABI, contractAddress, provider);
    try {
      const ownerResult = await contract.owner();
      setOwner(ownerResult);
      const nonceResult = await contract.nonce();
      setNonce(nonceResult.toString());
      setStatus("");
    } catch (err) {
      setStatus("Error reading contract");
    }
  }

  async function transferOwnership() {
    setStatus("Not implemented: Needs wallet signing");
    // To implement: Use starknet-react to send a transaction from the connected wallet
  }

  return (
    <div className="max-w-xl mx-auto p-4 space-y-6">
      <h1 className="text-2xl font-bold">Account Contract Dashboard</h1>
      <div className="flex flex-col gap-2">
        <label className="font-mono text-xs">Account Contract Address</label>
        <input
          className="border px-2 py-1 rounded"
          value={contractAddress}
          onChange={e => setContractAddress(e.target.value)}
          placeholder="0x..."
        />
        <button className="bg-blue-600 text-white rounded px-4 py-1 mt-2" onClick={fetchInfo}>
          Fetch Info
        </button>
      </div>
      <div className="space-y-2">
        <div>Owner: <span className="font-mono text-xs">{owner}</span></div>
        <div>Nonce: <span className="font-mono text-xs">{nonce}</span></div>
      </div>
      <div className="flex flex-col gap-2">
        <label className="font-mono text-xs">Transfer Ownership</label>
        <input
          className="border px-2 py-1 rounded"
          value={newOwner}
          onChange={e => setNewOwner(e.target.value)}
          placeholder="New owner address"
        />
        <button className="bg-green-600 text-white rounded px-4 py-1 mt-2" onClick={transferOwnership}>
          Transfer Ownership (WIP)
        </button>
      </div>
      {status && <div className="text-red-600">{status}</div>}
    </div>
  );
}

