// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {PoolFactory} from "../../src/PoolFactory.sol"; 
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
contract PoolFactoryTest() is Test {

     PoolFactory factory;
     ERC20Mock mockWeth;
     ERCMock20 tokenA;
     ERCMock20 tokenB;

     function setUp() public {
        mockWeth = new ERC20Mock();
        factory = new PoolFactory(address(mockWeth));
        tokenA = new ERC20Mock();
        tokenB = new ERC20Mock();
    }
     function testCreatePool



}
