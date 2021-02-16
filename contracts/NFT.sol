// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "./ERC1155/token/ERC1155.sol";
import "./ERC1155/access/Ownable.sol";


contract NFT is ERC1155, Ownable {
    constructor(string memory _uri) ERC1155(_uri) {}

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public /*onlyOwner()*/ {
        _mint(account, id, amount, data);
    }
}
