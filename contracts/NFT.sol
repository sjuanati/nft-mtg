// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "./ERC1155/token/ERC1155.sol";
import "./ERC1155/access/Ownable.sol";

/**
 * @title   NFT (Non Fungible Tokens)
 * @notice  ERC1155 contract based on OpenZeppelin implementation
 */
contract NFT is ERC1155, Ownable {
    constructor(string memory _uri) ERC1155(_uri) {}
    
    /**
     * @notice  Creates `amount` tokens of token type `id`, and assigns them to `account`
     * @param   account The address of the token holder
     * @param   id The ID of the token
     * @param   amount The Amount of tokens to be minted
     * @param   data Additional data with no specified format
     */
    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner() {
        _mint(account, id, amount, data);
    }
}
