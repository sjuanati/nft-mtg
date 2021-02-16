// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "./NFT.sol";
import "./ERC1155/access/Ownable.sol";

/**
 * @title   Magic The Gathering
 * @notice  tbc
 */
contract MTG is Ownable {
    NFT public token;
    uint256 id = 1;

    mapping(uint256 => NFT) public tokens;

    function create(string memory _uri) external onlyOwner() {
        tokens[id] = new NFT(_uri);
        id += 1;
    }

    function mint(
        address account,
        uint256 _id,
        uint256 amount,
        bytes memory data
    ) external onlyOwner() {
        require(address(tokens[_id]) != address(0), 'token does not exist');
        tokens[_id].mint(account, _id, amount, data);
    }
    
    function uri(uint256 _id) external view returns (string memory) {
        return tokens[_id].uri(_id);
    }

    function balanceOf(address account, uint256 _id)
        external
        view
        returns (uint256)
    {
        return tokens[_id].balanceOf(account, _id);
    }

    function transfer(
        address from,
        address to,
        uint256 _id,
        uint256 amount,
        bytes memory data
    ) external {
        tokens[_id].safeTransferFrom(from, to, _id, amount, data);
    }
}

