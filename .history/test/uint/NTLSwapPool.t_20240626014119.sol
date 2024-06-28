// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {NTLSwapPool} from "../../src/NTLSwap.sol"; 
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract NTLSwapPoolTest is Test {
    NTLSwapPool pool;
    ERC20Mock weth;
    ERC20Mock pool;
    ERC20Mock TokenB;

    address liquidityProvider = makeAddr("liquidityProvider");
    address user = makeAddr("user");
    function setUp () public{
         mockWeth = new ERC20Mock();
        factory = new PoolFactory(address(mockWeth));
        tokenA = new ERC20Mock();
        tokenB = new ERC20Mock();
    }

}
