// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {NTLSwapPool} from "../../src/NTLSwap.sol"; 
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract NTLSwapPoolTest is Test {
    NTLSwapPool pool;
    ERC20Mock weth;
    ERC20Mock poolToken;
   

    address liquidityProvider = makeAddr("liquidityProvider");
    address user = makeAddr("user");
    function setUp () public{
         poolToken = new ERC20Mock();
         weth = new ERC20
    }

}
