"use client";
import { StarknetConfig, InjectedConnector, publicProvider } from "@starknet-react/core";
import { ReactNode } from "react";

import { useEffect, useState } from "react";

export default function StarknetProvider({ children }: { children: React.ReactNode }) {
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);
  if (!mounted) return null;

  return (
    <StarknetConfig
      connectors={[
        new InjectedConnector({ options: { id: "argentX", name: "Argent X" } }),
        new InjectedConnector({ options: { id: "braavos", name: "Braavos" } })
      ]}
      provider={publicProvider()}
      autoConnect
    >
      {children}
    </StarknetConfig>
  );
}

