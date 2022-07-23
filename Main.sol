// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// importing NEW_NFT contract from NFT.sol file and Auction contract from Auction.sol file
import { NEW_NFT } from './NFT_creation.sol';
import { Auction } from './Auction.sol';

// creating new contract named "Transfer"
contract Transfer
{
    // defining parameters
    address public artist;  // the creator of the digital art
    address public art_owner; // the owner of the digital art
    address public topBidder; 
    uint256 public topBid;
    uint256 public closetime; // ending time
    uint256 NFT_token_ID;
    uint256 NEW_NFT_token_ID;
    uint256 NFT_ID;
    address first_owner;
    address second_owner;
    string art;
    
    uint256 time_to_bid = 1 * 24 * 60 * 60; // 1 day in seconds

    // defining function to create NFT token.
    function generate_NFT(address _owner, string memory digital_art)
    private
    returns (uint256)
    {   
        // generating NFT token
        NEW_NFT NFT_token = new NEW_NFT();   
        NFT_token_ID = NFT_token.mintNFT(_owner, digital_art);
        // checking whether NFT_token_ID is null if not, then return it
        require(NFT_token_ID != 0);
        return NFT_token_ID;
    }

    function NFT_token_transfer(address from, address to, uint256 ID)
    private
    {   
        // function for transfering NFT token to from one address to another (owner -> highest bidder)
        NEW_NFT NFT_token = new NEW_NFT();
        NFT_token.token_transfer(from, to, ID);
    }

    function NFT_transfer_by_auction(address NFT_owner, uint256 ID)
    private
    returns (address)
    {
        // transferring the digital asset by auction
        Auction auction = new Auction();

        auction.auction(NFT_owner,time_to_bid);

        // running the auction untill the closing time
        while (block.timestamp <= closetime)
        {
            auction.biding();
        }

        // closing the auction
        auction.auctionClose();

        // required fields
        require(topBidder != address(0));
        require(topBidder != NFT_owner);
        require(topBid != 0);
        //require(topBid > lowest_bid);

        // after the above requirement gets fullfilled then transfer the token to top bidder
        NFT_token_transfer(NFT_owner, topBidder, ID);

        
        // 1% royalty to the artist
        payable(artist).transfer(topBid*1/100);

        return topBidder;
    }

    function main()
    public
    {
        NEW_NFT_token_ID = generate_NFT(art_owner, art); // calling generate_NFT function and storing token id in variable

        first_owner = NFT_transfer_by_auction(art_owner, NFT_ID); // first owner

        second_owner = NFT_transfer_by_auction(first_owner, NFT_ID);  // second owner
    }
}
