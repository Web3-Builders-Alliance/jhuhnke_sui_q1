import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519"; 
import { fromB64, toHEX } from "@mysten/sui.js/utils"; 
import { fromHEX } from "@mysten/bcs";

let kp = Ed25519Keypair.generate(); 
console.log(`You've generated a new SUI wallet: ${kp.toSuiAddress()}`)

// convert existing private key to keypair
//let pk = '<shh secret>'; 
//console.log(fromHEX(pk))

// To save wallet - copy this into a JSON file
console.log(fromB64(kp.export().privateKey))

// Use this hex to import the key into a web wallet
console.log(toHEX(fromB64(kp.export().privateKey)));