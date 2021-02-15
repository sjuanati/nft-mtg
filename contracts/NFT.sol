// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "./ERC1155/token/ERC1155.sol";

contract NFT is ERC1155 {
    constructor(string memory _uri) ERC1155(_uri) {}

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public  {
        _mint(account, id, amount, data);
    }


}
