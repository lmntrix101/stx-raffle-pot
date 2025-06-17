 STX Raffle Pot Smart Contract

**STX Raffle Pot** is a decentralized and transparent on-chain raffle system built using Clarity on the Stacks blockchain. It allows users to enter a raffle by depositing STX, and a winner is selected pseudo-randomly to receive the accumulated pot.

---

 Features

-  **Fixed Entry Raffle** – Users enter by sending a predefined STX amount.
-  **On-chain Logic** – All ticketing, pot accumulation, and winner selection are handled by smart contract logic.
-  **Fair Draw Mechanism** – Uses block hash as a basic randomness source for winner selection.
-  **Winner History** – Stores data about each round and the winner's address.
-  **Trustless** – No need for a third party or admin control once deployed.

---

 Contract Details

- **Contract Name:** `stx-raffle-pot`
- **Language:** Clarity
- **Network:** Stacks Mainnet/Testnet
- **Entry Fee:** Configurable (default: 10 STX)
- **Max Entries per Raffle:** Optional limit (configurable)

---

 How It Works

1. Users enter the raffle by calling `enter-raffle` with the entry fee.
2. Once the number of participants reaches a threshold, or an admin triggers it, `draw-winner` is called.
3. A winner is pseudo-randomly selected using block hash.
4. The total STX pot is transferred to the winner's address.
5. Raffle round resets and opens for the next participants.

---

 Smart Contract Functions

| Function          | Access  | Description                                 |
|------------------|---------|---------------------------------------------|
| `enter-raffle`   | Public  | Allows users to participate in the raffle   |
| `draw-winner`    | Admin   | Selects a winner and distributes STX pot    |
| `get-entries`    | Read-Only | Returns current list of participants       |
| `get-winner`     | Read-Only | Returns winner of the last round           |
| `get-pot`        | Read-Only | Returns current STX pot                    |

---

 Deployment

1. Install [Clarinet](https://docs.stacks.co/docs/clarity/clarinet-cli/overview/)
2. Clone this repo
3. Compile and test:
   ```bash
   clarinet check
   clarinet test
