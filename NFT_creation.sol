// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC721 is a standard for representing ownership of non-fungible tokens, that is, where each token is unique.
// importing required ERC271 modules 
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// creating a contract named NEW_NFT
contract NEW_NFT is ERC721URIStorage, Ownable
{
    // importing counters
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;
    
    // creating a constructor for generating token using ERC721
    constructor() ERC721("NEW_NFT", "NFT") {}

    function mintNFT(address recipient, string memory tokenURI)
    public onlyOwner
    returns (uint256)  
    {
        // incrementing tokenIDs
        tokenIds.increment();

        // assigning the current tokenIds to new item_Id
        uint256 new_item_Id = tokenIds.current();
        _mint(recipient, new_item_Id);

        // setting token URI
        _setTokenURI(new_item_Id, tokenURI);

        return new_item_Id;
    }
    // defining function for transferring the token
    function token_transfer(address from, address to, uint256 ID)
    public onlyOwner
    {
        // transferring the token from one address to another (here, owner -> highest bidder)
        safeTransferFrom(from, to, ID);
    }
}
