// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import {NFT} from "./NFT.sol";
import {ERC1155Receiver} from "./ERC1155/token/ERC1155Receiver.sol";

/**
 * @title   The Receiver
 * @notice  Contract that receives ERC1155 tokens through the ERC165 standard
 */
contract Receiver is ERC1155Receiver {
    // Struct to have a record of the received tokens (optional)
    struct Token {
        address operator;
        address from;
        uint256 id;
        uint256 value;
        bytes data;
    }

    // Mapping token ID => Token data
    mapping(uint256 => Token) public tokens;

    /**
     * @notice  Handles the receipt of a single ERC1155 token type
     * @param   operator The address which initiated the transfer (i.e. msg.sender)
     * @param   from The address which previously owned the token
     * @param   id The ID of the token being transferred
     * @param   value The amount of tokens being transferred
     * @param   data Additional data with no specified format
     * @return  `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
     */
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

    /**
     * @notice  Handles the receipt of a multiple ERC1155 token types
     * @param   operator The address which initiated the transfer (i.e. msg.sender)
     * @param   from The address which previously owned the token
     * @param   ids An array containing ids of each token being transferred (order and length must match values array)
     * @param   values An array containing amounts of each token being transferred (order and length must match ids array)
     * @param   data Additional data with no specified format
     * @return  `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
     */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external override returns (bytes4) {
        for (uint256 i = 0; i < ids.length; i++) {
            tokens[i] = Token(operator, from, ids[i], values[i], data);
        }
        return this.onERC1155BatchReceived.selector;
    }
}
