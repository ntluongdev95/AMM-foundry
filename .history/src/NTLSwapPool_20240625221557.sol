// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NTLSwapPool is ERC20 {
    error NTLSwapPool__MustBeMoreThanZero();
    error NTLSwapPool__WethDepositAmountTooLow(uint256 minimumWethDeposit, uint256 wethToDeposit);
    error NTLSwapPool__MaxPoolTokenDepositTooHigh(uint256 maximumPoolTokensToDeposit, uint256 poolTokensToDeposit);
    error NTLSwapPool__MinLiquidityTokensToMintTooLow(
        uint256 minimumLiquidityTokensToMint, uint256 liquidityTokensToMint
    );
    error NTLSwapPool__DeadlineHasPassed(uint64 deadline);
    error NTLSwapPool__OutputTooLow(uint256 wethToWithdraw,uint256 minWethToWithdraw);

    using SafeERC20 for IERC20;

    IERC20 private immutable i_poolToken;
    IERC20 private immutable i_wethToken;
    uint256 private constant MINIMUM_WETH_LIQUIDITY = 1_000_000_000;
    uint256 private swap_count = 0;
    uint256 private constant SWAP_COUNT_MAX = 10;

    /////EVENT///
    event LiquidityAdded(address indexed liquidityProvider, uint256 wethDeposited, uint256 poolTokensDeposited);
    event LiquidityRemoved(address indexed liquidityProvider, uint256 wethWithdrawn, uint256 poolTokensWithdrawn);
    event Swap(address indexed swapper, IERC20 tokenIn, uint256 amountTokenIn, IERC20 tokenOut, uint256 amountTokenOut);

    modifier revertIfZero(uint256 amount) {
        if (amount == 0) {
            revert NTLSwapPool__MustBeMoreThanZero();
        }
        _;
    }

    modifier revertIfDeadlinePassed(uint64 deadline) {
        if (deadline < uint64(block.timestamp)) {
            revert NTLSwapPool__DeadlineHasPassed(deadline);
        }
        _;
    }

    constructor(
        address poolToken,
        address wethToken,
        string memory liquidityTokenName,
        string memory liquidityTokenSymbol
    ) ERC20(liquidityTokenName, liquidityTokenSymbol) {
        i_poolToken = IERC20(poolToken);
        i_wethToken = IERC20(wethToken);
    }

    function deposit(
        uint256 wethToDeposit,
        uint256 minimumLiquidityTokensToMint,
        uint256 maximumPoolTokensToDeposit,
        uint64 deadline
    ) external revertIfZero(wethToDeposit) returns (uint256 liquidityTokensToMint) {
        if (wethToDeposit < MINIMUM_WETH_LIQUIDITY) {
            revert NTLSwapPool__WethDepositAmountTooLow(MINIMUM_WETH_LIQUIDITY, wethToDeposit);
        }
        if (totalLiquidityTokenSupply() > 0) {
            uint256 wethReserves = i_wethToken.balanceOf(address(this));
            uint256 poolTokenReserves = i_poolToken.balanceOf(address(this));
            uint256 poolTokensToDeposit = getPoolTokensToDepositBasedOnWeth(wethToDeposit);
            if (poolTokensToDeposit > maximumPoolTokensToDeposit) {
                revert NTLSwapPool__MaxPoolTokenDepositTooHigh(maximumPoolTokensToDeposit, poolTokensToDeposit);
            }
            liquidityTokensToMint = (wethToDeposit * totalLiquidityTokenSupply()) / wethReserves;
            if (liquidityTokensToMint < minimumLiquidityTokensToMint) {
                revert NTLSwapPool__MinLiquidityTokensToMintTooLow(minimumLiquidityTokensToMint, liquidityTokensToMint);
            }
            _addLiquidityMintAndTransfer(wethToDeposit, poolTokensToDeposit, liquidityTokensToMint);
        } else {
            _addLiquidityMintAndTransfer(wethToDeposit, maximumPoolTokensToDeposit, wethToDeposit);
            liquidityTokensToMint = wethToDeposit;
        }
    }

    /*
    caculate token to withdraw
    dx = X*S/T
    dy = Y*S/T
    S:liquidityTokensToBurn
    X:reserve X
    T:totalLiquidityTokenSupply
    */

    function withdraw(
        uint256 liquidityTokensToBurn,
        uint256 minWethToWithdraw,
        uint256 minPoolTokensToWithdraw,
        uint64 deadline
    )
        external
        revertIfDeadlinePassed(deadline)
        revertIfZero(liquidityTokensToBurn)
        revertIfZero(minWethToWithdraw)
        revertIfZero(minPoolTokensToWithdraw)
    {
         uint256 wethToWithdraw = (liquidityTokensToBurn *
            i_wethToken.balanceOf(address(this))) / totalLiquidityTokenSupply();
        uint256 poolTokensToWithdraw = (liquidityTokensToBurn *
            i_poolToken.balanceOf(address(this))) / totalLiquidityTokenSupply();

         if (wethToWithdraw < minWethToWithdraw) {
            revert NTLSwapPool__OutputTooLow(wethToWithdraw, minWethToWithdraw);
        }
        if (poolTokensToWithdraw < minPoolTokensToWithdraw) {
            revert NTLSwapPool__OutputTooLow(
                poolTokensToWithdraw,
                minPoolTokensToWithdraw
            );
        }
        _burn(msg.sender, liquidityTokensToBurn);
        emit LiquidityRemoved(msg.sender, wethToWithdraw, poolTokensToWithdraw);

        i_wethToken.safeTransfer(msg.sender, wethToWithdraw);
        i_poolToken.safeTransfer(msg.sender, poolTokensToWithdraw);

    }

    function getOutputAmountBasedOnInput()

    function _addLiquidityMintAndTransfer(
        uint256 wethToDeposit,
        uint256 poolTokensToDeposit,
        uint256 liquidityTokensToMint
    ) private {
        _mint(msg.sender, liquidityTokensToMint);
        emit LiquidityAdded(msg.sender, poolTokensToDeposit, wethToDeposit);

        // Interactions
        i_wethToken.safeTransferFrom(msg.sender, address(this), wethToDeposit);
        i_poolToken.safeTransferFrom(msg.sender, address(this), poolTokensToDeposit);
    }

    //View function
    function totalLiquidityTokenSupply() public view returns (uint256) {
        return totalSupply();
    }
    /*
    share = dx/x*T = Dy/y*T {
      T:total shares before
      dx: amount of x added
      dy : amount of y added
    }
    */

    function getPoolTokensToDepositBasedOnWeth(uint256 wethToDeposit) public view returns (uint256) {
        uint256 poolTokenReserves = i_poolToken.balanceOf(address(this));
        uint256 wethReserves = i_wethToken.balanceOf(address(this));
        return (wethToDeposit * poolTokenReserves) / wethReserves;
    }
}
