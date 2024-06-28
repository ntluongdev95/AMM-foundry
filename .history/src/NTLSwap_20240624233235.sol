// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NTLSwap is ERC20{

    IERC20 private immutable i_poolToken;
    IERC20 private immutable i_wethToken;

    constructor (
        address poolToken,
        address wethToken,
        string memory liquidityTokenName,
        string memory liquidityTokenSymbol
    ) ERC20( liquidityTokenName, liquidityTokenSymbol){
      i_poolToken = IERC20(poolToken);
        i_wethToken = IERC20(wethToken);

    }

}