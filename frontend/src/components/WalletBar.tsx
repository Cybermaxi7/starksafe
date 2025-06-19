"use client";
import { useAccount, useConnect, useDisconnect } from "@starknet-react/core";

export default function WalletBar() {
  const { address, isConnected } = useAccount();
  const { connect, connectors } = useConnect();
  const { disconnect } = useDisconnect();

  return (
    <div className="flex items-center gap-4 p-2 border-b">
      {isConnected ? (
        <>
          <span className="font-mono text-xs">{address}</span>
          <button
            className="px-2 py-1 rounded bg-gray-200 hover:bg-gray-300 text-xs"
            onClick={() => disconnect()}
          >
            Disconnect
          </button>
        </>
      ) : (
        <button
          className="px-2 py-1 rounded bg-blue-600 hover:bg-blue-700 text-white text-xs"
          onClick={() => connect({ connector: connectors[0] })}
        >
          Connect Wallet
        </button>
      )}
    </div>
  );
}
