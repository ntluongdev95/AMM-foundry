// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import { Script } from "forge-std/Script.sol";
import {PoolFactory} from "../src/PoolFactory.sol";
import{NTLSwapPool} from "../src/NTLSwapPool.sol";
import {}

contract DeployNTLSwap is Script{
    address public constant WETH_TOKEN_MAINNET = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    uint256 public constant MAINNET_CHAIN_ID = 1;
    function run() external {
         vm.startBroadcast();
       if(block.chainid == MAINNET_CHAIN_ID){
           new PoolFactory(WETH_TOKEN_MAINNET);
       }else{
           address weth = new
       }
    }



}