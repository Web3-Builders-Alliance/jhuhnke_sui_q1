import { getFullnodeUrl, SuiClient } from "@mysten/sui.js/client"; 
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import wallet from './wallet.json'; 

// Import Dev wallet keypair 
const keypair = Ed25519Keypair.fromSecretKey(new Uint8Array(wallet)); 

// Define WBA SUI Address
const to = "0x03070b1ccbc5368b070b9dd45db266ccc7e68f642e204517c7d49fc46d057642"; 

// Create devnet client
const client = new SuiClient({ url: getFullnodeUrl("devnet")}); 

(async () => {
    try {
        const txb = new TransactionBlock(); 
        txb.transferObjects([txb.gas], to); 
        let txid = await client.signAndExecuteTransactionBlock({ signer: keypair, transactionBlock: txb }); 
        console.log(`Success! Check out your txid here: 
        https://suiexplorer.com/txblock/${txid.digest}?network=devnet`); 
    } catch(e) {
        console.error(`Oops, something went wrong: ${e}`)
    }
})(); 