// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "./NFT.sol";

/**
 * @title   Magic The Gathering
 * @notice  tbc
 */
contract MTG {
    NFT public token;

    constructor(address tokenAddress) {
        token = NFT(tokenAddress);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external {
        token.mint(account, id, amount, data);
    }

    function balanceOf(address account, uint256 id)
        external
        view
        returns (uint256)
    {
        return token.balanceOf(account, id);
    }
}
