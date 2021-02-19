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
    uint256 idNFT = 1;

    // Mapping tokenID => NFT
    mapping(uint256 => NFT) public tokens;

    /**
     * @notice  Create a new ERC1155 Token
     * @param   _uri URI pointing to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema"
     */
    function create(string memory _uri) external onlyOwner() {
        // TODO: Check IPFS hash in mapping(uint256 => uint8) to prevent issuing tokens mapped to previous hashes
        tokens[idNFT] = new NFT(_uri);
        idNFT += 1;
    }

    /**
     * @notice  Mint new tokens within an existing ERC1155 Token
     * @param   account The address of the token holder
     * @param   _idNFT The ID of the NFT contract
     * @param   _id The ID of the token type
     * @param   amount The Amount of tokens to be minted
     * @param   data Additional data with no specified format
     */
    function mint(
        address account,
        uint256 _idNFT,
        uint256 _id,
        uint256 amount,
        bytes memory data
    ) external onlyOwner() {
        require(
            address(tokens[_idNFT]) != address(0),
            "token contract does not exist"
        );
        tokens[_idNFT].mint(account, _id, amount, data);
    }

    /**
     * @notice  Get the URI of the token requested
     * @param   _idNFT The ID of the NFT contract
     * @param   _id The ID of the token type
     * @return  The URI of the token requested
     */
    function uri(uint256 _idNFT, uint256 _id)
        external
        view
        returns (string memory)
    {
        return tokens[_idNFT].uri(_id);
    }

    /**
     * @notice  Get the balance of an account's tokens
     * @param   owner The address of the token holder
     * @param   _idNFT The ID of the NFT contract
     * @param   _id The ID of the token type
     * @return  The owner's balance of the token requested
     */
    function balanceOf(
        address owner,
        uint256 _idNFT,
        uint256 _id
    ) external view returns (uint256) {
        return tokens[_idNFT].balanceOf(owner, _id);
    }

    /**
     * @notice  Get the address of an account's tokens
     * @param   _idNFT The ID of the NFT contract
     * @return  The address of the token requested
     */
    function addressOf(uint256 _idNFT) external view returns (address) {
        return address(tokens[_idNFT]);
    }

    /**
     * @notice  Queries the approval status of an operator for a given token holder
     * @param   owner The address of the token holder
     * @param   operator The address of the authorized operator
     * @param   _idNFT The ID of the NFT contract
     * @return  True if the operator is approved, false if not
     */
    function isApproved(
        address owner,
        address operator,
        uint256 _idNFT
    ) external view returns (bool) {
        return tokens[_idNFT].isApprovedForAll(owner, operator);
    }

    /**
     * @notice  Emergency switch to pause all transfers
     * @param   _idNFT The ID of the NFT contract
     */
    function pause(uint256 _idNFT) external onlyOwner() {
        tokens[_idNFT].pause();
    }

    /**
     * @notice  Emergency switch to unpause all transfers
     * @param   _idNFT The ID of the NFT contract
     */
    function unpause(uint256 _idNFT) external onlyOwner() {
        tokens[_idNFT].unpause();
    }

    /**
     * @notice  Queries the Emergency switch status
     * @param   _idNFT The ID of the NFT contract
     * @return  True if the contract is paused, false if not
     */
    function isPaused(uint256 _idNFT) external view returns (bool) {
        return tokens[_idNFT].paused();
    }
}
