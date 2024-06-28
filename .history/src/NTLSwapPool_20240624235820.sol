// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NTLSwapPool is ERC20{

    error NTLSwapPool__MustBeMoreThanZero();
    error NTLSwapPool__WethDepositAmountTooLow(
        uint256 minimumWethDeposit,
        uint256 wethToDeposit
    );

    IERC20 private immutable i_poolToken;
    IERC20 private immutable i_wethToken;
    uint256 private constant MINIMUM_WETH_LIQUIDITY = 1_000_000_000;
    uint256 private swap_count = 0;
    uint256 private constant SWAP_COUNT_MAX = 10;


     modifier revertIfZero(uint256 amount) {
        if (amount == 0) {
            revert NTLSwapPool__MustBeMoreThanZero();
        }
        _;
    }

    constructor (
        address poolToken,
        address wethToken,
        string memory liquidityTokenName,
        string memory liquidityTokenSymbol
    ) ERC20( liquidityTokenName, liquidityTokenSymbol){
        i_poolToken = IERC20(poolToken);
        i_wethToken = IERC20(wethToken);
    }

    function deposit (
        uint256 wethToDeposit,
        uint256 minimumLiquidityTokensToMint,
        uint256 maximumPoolTokensToDeposit,
        uint64 deadline
    ) external revertIfZero(wethToDeposit)
       returns (uint256 liquidityTokensToMint)
     {
    if(wethToDeposit < MINIMUM_WETH_LIQUIDITY){
        revert NTLSwapPool__WethDepositAmountTooLow(
            MINIMUM_WETH_LIQUIDITY,
            wethToDeposit
        );
        
    }

}
}