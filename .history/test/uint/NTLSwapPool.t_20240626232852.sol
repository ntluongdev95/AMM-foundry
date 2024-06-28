// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {NTLSwapPool} from "../../src/NTLSwapPool.sol"; 
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract NTLSwapPoolTest is Test {
    NTLSwapPool pool;
    ERC20Mock weth;
    ERC20Mock poolToken;
   
    uint256 public constant MINIMUM_WETH_LIQUIDITY = 1_000_000_000;
    address liquidityProvider = makeAddr("liquidityProvider");
    address user = makeAddr("user");
    function setUp () public{
         poolToken = new ERC20Mock();
         weth = new ERC20Mock();
         pool = new NTLSwapPool(address(poolToken), address(weth), "liquidityTokenName", "liquidityTokenSymbol");
         weth.mint(liquidityProvider,200e18);
         poolToken.mint(liquidityProvider,200e18);
        weth.mint(user, 10e18);
        poolToken.mint(user, 10e18);
    }

    function test_deposit () public{
         vm.startPrank(liquidityProvider);
        weth.approve(address(pool), 100e18);
        poolToken.approve(address(pool), 100e18);
        pool.deposit(100e18, 100e18, 100e18, uint64(block.timestamp));

        assertEq(pool.balanceOf(liquidityProvider), 100e18);
        assertEq(weth.balanceOf(liquidityProvider), 100e18);
        assertEq(poolToken.balanceOf(liquidityProvider), 100e18);

        assertEq(weth.balanceOf(address(pool)), 100e18);
        assertEq(poolToken.balanceOf(address(pool)), 100e18);
    }
    function test_RevertIfZero () public{
        vm.startPrank(liquidityProvider);
        vm.expectRevert(NTLSwapPool.NTLSwapPool__MustBeMoreThanZero.selector);
        pool.deposit(0, 100e18, 100e18, uint64(block.timestamp));
    }

    function test_RevertWethDepositAmountTooLow ()public{
        vm.startPrank(liquidityProvider);
         abi.encodeWithSelector(
           NTLSwapPool.NTLSwapPool__WethDepositAmountTooLow.selector,
            swapPool.MINIMUM_WETH_LIQUIDITY(),
            wethToDeposit
        );
        weth.approve(address(pool),100000000);
        poolToken.approve(address(pool), 100e18);
        pool.deposit(100000000, 100e18, 100e18, uint64(block.timestamp));
    }

}
