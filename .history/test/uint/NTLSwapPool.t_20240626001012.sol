// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
impr
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract NTLSwapPoolTest is Test {
  
    ERC20Mock weth;
    ERC20Mock tokenA;
    ERC20Mock TokenB;
    function setUp () public{
         mockWeth = new ERC20Mock();
        factory = new PoolFactory(address(mockWeth));
        tokenA = new ERC20Mock();
        tokenB = new ERC20Mock();
    }

}
