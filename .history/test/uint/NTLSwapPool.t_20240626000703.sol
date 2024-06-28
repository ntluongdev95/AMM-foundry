// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {PoolFactory} from "../../src/PoolFactory.sol";
import {DeployNTLSwap} from "../../script/DeployNTLSwap.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract NTLSwapPool is Test {
    PoolFactory poolFactory;
    ERC20Mock weth;
    ERC20Mock tokenA;
    ERC20Mock TokenB;
    
}
