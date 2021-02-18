// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "./NFT.sol";
import "./ERC1155/access/Ownable.sol";

/**
 * @title   MTG (Magic The Gathering)
 * @notice  Factory contract to manage ERC1155-based tokens
 */
contract MTG is Ownable {
    // ID token counter
    uint256 id = 1;

    // Mapping tokenID => NFT
    mapping(uint256 => NFT) public tokens;

    /**
     * @notice  Create a new ERC1155 Token
     * @param   _uri URI pointing to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema"
     */
    function create(string memory _uri) external onlyOwner() {
        // TODO: Check IPFS hash in mapping(uint256 => uint8) to prevent issuing tokens mapped to previous hashes
        tokens[id] = new NFT(_uri);
        id += 1;
    }

    /**
     * @notice  Mint new tokens within an existing ERC1155 Token
     * @param   account The address of the token holder
     * @param   _id The ID of the token
     * @param   amount The Amount of tokens to be minted
     * @param   data Additional data with no specified format
     */
    function mint(
        address account,
        uint256 _id,
        uint256 amount,
        bytes memory data
    ) external onlyOwner() {
        require(address(tokens[_id]) != address(0), "token does not exist");
        tokens[_id].mint(account, _id, amount, data);
    }

    /**
     * @notice  Get the URI of the token requested
     * @param   _id The ID of the token
     * @return  The URI of the token requested
     */
    function uri(uint256 _id) external view returns (string memory) {
        return tokens[_id].uri(_id);
    }

    /**
     * @notice  Get the balance of an account's tokens
     * @param   owner The address of the token holder
     * @param   _id The ID of the token
     * @return  The owner's balance of the token requested
     */
    function balanceOf(address owner, uint256 _id)
        external
        view
        returns (uint256)
    {
        return tokens[_id].balanceOf(owner, _id);
    }

    /**
     * @notice  Get the address of an account's tokens
     * @param   _id The ID of the token
     * @return  The address of the token requested
     */
    function addressOf(uint256 _id) external view returns (address) {
        return address(tokens[_id]);
    }

    /**
     * @notice  Queries the approval status of an operator for a given token holder
     * @param   owner The address of the token holder
     * @param   operator The address of the authorized operator
     * @param   _id The ID of the token
     * @return  True if the operator is approved, false if not
     */
    function isApproved(
        address owner,
        address operator,
        uint256 _id
    ) external view returns (bool) {
        return tokens[_id].isApprovedForAll(owner, operator);
    }

    // Pause
    function pause(uint256 _id) external onlyOwner() {
        tokens[_id].pause();
    }

    // Unpause
    function unpause(uint256 _id) external onlyOwner() {
        tokens[_id].unpause();
    }

    function isPaused(uint256 _id) external view returns (bool) {
        return tokens[_id].paused();
    }
}
