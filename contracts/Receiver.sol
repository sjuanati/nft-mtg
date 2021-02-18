// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import {NFT} from "./NFT.sol";
import {ERC1155Receiver} from "./ERC1155/token/ERC1155Receiver.sol";

contract Receiver is ERC1155Receiver {

    struct Token {
        address operator;
        address from;
        uint256 id;
        uint256 value;
        bytes data;
    }

    mapping(uint256 => Token) public tokens;

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external override returns (bytes4) {
        tokens[id] = Token(operator, from, id, value, data);
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external override returns (bytes4) {
        for (uint i=0; i<ids.length; i++) {
            tokens[i] = Token(operator, from, ids[i], values[i], data);
        }
        return this.onERC1155BatchReceived.selector;
    }
}
